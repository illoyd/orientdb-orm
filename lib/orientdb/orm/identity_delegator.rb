module Orientdb
  module ORM

    ##
    # A delegator that will return itself rather than the delegated object.
    class IdentityDelegator < SimpleDelegator
      def method_missing(m, *args, &block)
        response = super
        response == __getobj__ ? self : response
      end
    end

  end
end