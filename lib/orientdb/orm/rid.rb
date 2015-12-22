module Orientdb
module ORM
  class RID

    attr_reader :collection, :position

    RID_REGEX = /#?(-?\d+):(-?\d+)/

    def initialize(collection, position)
      @collection, @position = collection, position
    end

    def self.call(value)
      case value
      when RID
        value
      when RID_REGEX
        new($1.to_i, $2.to_i)
      else
        new(-1, -1)
      end

      rescue
        new(-1, -1)
    end

    def valid?
      !@collection.nil? && !@position.nil?
    end

    def persisted?
      valid? && @collection >= 0 && @position >= 0
    end

    def to_s
      "##{ @collection || 'NIL' }:#{ @position || 'NIL' }"
    end

    def to_short_s
      "#{ @collection || 'NIL' }:#{ @position || 'NIL' }"
    end

    def inspect
      "<RID #{ to_s }>"
    end

    def ==(other)
      case other
      when RID
        collection == other.collection && position == other.position
      else
        self == RID.call(other)
      end
    end
  end
end
end