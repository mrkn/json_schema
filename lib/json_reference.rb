require "uri"
require_relative "json_pointer"

module JsonReference
  class Reference
    attr_accessor :pointer
    attr_accessor :uri

    def initialize(ref)
      # given a simple fragment without '#', resolve as a JSON Pointer only as
      # per spec
      if ref.include?("#")
        uri, @pointer = ref.split('#')
        if uri && !uri.empty?
          @uri = URI.parse(uri)
        end
        @pointer ||= ""
      else
        @pointer = ref
      end

      # normalize pointers by prepending "#"
      @pointer = "#" + @pointer
    end

    # Given the document addressed by #uri, resolves the JSON Pointer part of
    # the reference.
    def resolve_pointer(data)
      JsonPointer.evaluate(data, @pointer)
    end

    def to_s
      if @uri
        "#{@uri.to_s}#{@pointer}"
      else
        @pointer
      end
    end
  end
end
