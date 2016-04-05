module Orientdb
  module ORM
    module Queries

      class Lazy < SimpleDelegator

        delegate :first, :last, :each, :map, :count, :to_a, :[], to: :execute

        def execute
          @result ||= __getobj__.execute
        end

        def method_missing(m, *args, &block)
          response = super
          response == __getobj__ ? self : response
        end
      end

    end
  end
end