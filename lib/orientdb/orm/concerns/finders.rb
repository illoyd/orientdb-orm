module Orientdb
  module ORM
    module Finders
      extend ActiveSupport::Concern

      included do
      end
      
      class_methods do
        
        def all
          where
        end
        
        def where(search={})
          Orientdb::ORM::Queries::Select.new.from(self.name.demodulize).where(search).execute
        end
        
        def find_by(search={})
          where(search).first
        end
        
        def find(rid)
          find_by( '@rid' => rid )
        end
        
        alias :find_by_id :find
        alias :find_by_rid :find

      end

    end
  end
end