module Orientdb
  module ORM

    class Error < StandardError
      attr_reader :original
      def initialize(msg, orig = $!)
        super(msg)
        @original = orig
      end
    end

    class ObjectError < Error
      attr_reader :object
      def initialize(msg, object, orig = $!)
        super(msg, orig)
        @object = object
      end
    end

    class InvalidConnectionUrlError < Error; end

    class ObjectNotSaved < ObjectError; end

    class ObjectInvalid < ObjectError; end

    class ObjectNotFound < Error; end

  end
end