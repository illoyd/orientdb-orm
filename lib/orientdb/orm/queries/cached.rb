module Orientdb
  module ORM
    module Queries

      ##
      # Cache the results of executing a query or command.
      class Cached < IdentityDelegator

        def execute
          @cached_result ||= __getobj__.execute
        end

        def cached_result
          @cached_result
        end

        def clear_cached_result!
          @cached_result = nil
        end

      end

    end
  end
end