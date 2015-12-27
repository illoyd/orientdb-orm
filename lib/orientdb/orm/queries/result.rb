module Orientdb
  module ORM
    module Queries

      class Result
        include Enumerable
        
        delegate :size, :empty?, to: :raw_results
        attr_reader :raw_results
        
        def initialize(results)
          @raw_results = Array(results)
          @results     = []
        end
        
        def [](index)
          @results[index] ||= coerce(index)
        end
        
        def each
          return enum_for(:each) unless block_given?
          @raw_results.size.times { |n| yield self[n] }
        end

        def first
          self[0] unless empty?
        end
        
        def last
          self[size-1] unless empty?
        end
        
        protected
        
        def coerce(index)
          if @raw_results[index]['@class'].present?
            klass = class_for(@raw_results[index]['@class'])
            klass.new(@raw_results[index])
          else
            @raw_results[index]
          end
        end
        
        def class_for(klass)
          # klass.constantize
          eval(klass)
        end

      end
  
    end
  end
end