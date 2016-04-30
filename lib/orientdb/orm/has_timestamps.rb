module Orientdb
  module ORM
    module HasTimestamps
      extend ActiveSupport::Concern

      included do
        # Name, kind, default, validations
        attribute :created_at, :datetime
        attribute :updated_at, :datetime

        # Hook into callbacks
        before_create :ensure_created_at
        before_update :ensure_updated_at

        protected

        def ensure_created_at
          self.created_at = self.updated_at = DateTime.now.utc
        end

        def ensure_updated_at
          self.updated_at = DateTime.now.utc
        end

      end

      class_methods do
      end

    end
  end
end