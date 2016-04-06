module Orientdb
  module ORM
    module Queries

      class LazyResult < IdentityDelegator

        delegate :first, :last, :each, :map, :count, :to_a, :[], to: :execute

      end

    end
  end
end