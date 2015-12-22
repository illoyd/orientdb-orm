module Orientdb
  module ORM
    
    class Error < StandardError
      def initialize(msg, orig = $!)
        super(msg)
        @original = orig
      end
    end
    
    class InvalidConnectionUrlError < Error; end

  end
end