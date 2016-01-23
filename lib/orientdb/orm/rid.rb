module Orientdb
  module ORM
    class RID
      include Comparable

      attr_reader :collection, :position

      RID_REGEX = /#?(-?\d+):(-?\d+)/

      def initialize(collection, position)
        @collection, @position = collection, position
      end

      ##
      # Get the object referenced by this RID.
      def fetch
        Orientdb::ORM::Queries::Select.new.from(self).execute.first
      end

      ##
      # Determines if this RID is valid.
      def valid?
        !@collection.nil? && !@position.nil?
      end

      ##
      # Determines if this RID is persisted (both collection and position must be greater than or equal to 0).
      # A negative in either collection or position implies an object not yet persisted.
      def persisted?
        valid? && @collection >= 0 && @position >= 0
      end

      ##
      # Convert to a canonical RID format.
      def to_s
        "##{ @collection || 'NIL' }:#{ @position || 'NIL' }"
      end

      ##
      # Convert to the string RID, without the preceeding #.
      def to_param
        persisted? ? "#{ @collection }:#{ @position }" : nil
      end

      ##
      # Pretty print this object.
      def inspect
        "<RID #{ to_s }>"
      end

      ##
      # Comparable function.
      def <=>(other)
        return nil unless other.respond_to?(:collection) && other.respond_to?(:position)
        return self.collection <=> other.collection if (self.collection <=> other.collection) != 0
        self.position <=> other.position
      end

      ##
      # Equals other if other is a RID or can be cast into a RID
      # HACK Fix the comparison logic here...
      def ==(other)
        self.eql?(other) || ( !other.is_a?(RID) && self == Orientdb::ORM::Type.lookup(:link).cast(other) )
      end

      ##
      # Strictly requires other to be a RID
      def eql?(other)
        other.is_a?(RID) && collection == other.collection && position == other.position
      end

    end
  end
end