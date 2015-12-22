module Orientdb
module ORM
  class FieldType

    attr_reader :field_types
    delegate :[]=, :merge, :merge!, to: :field_types

    ##
    # Create a new FieldType.
    def initialize(field_types={})
      field_types ||= {}
      @field_types = self.class.default_field_types.reverse_merge(field_types)
    end
    
    def self.default_field_types
      { '@rid' => RID, '@fieldTypes' => FieldType }
    end

    ##
    # Convert to a thingie.
    def to_s
      @field_types.except(*Document::PROTECTED_KEYS).map { |rule| rule.join('=') }.join(',')
    end

    ##
    # Coerce a given value by the specified key.
    # If it cannot be coerced, the original value is returned.
    def coerce(key, value)
      self[key].try(:call, value) || value
    end

    ##
    # Map
    def [](key)
      case @field_types[key].try(:strip)
      when 'f' # for float
        FloatConverter
      when 'b' # for boolean
        BooleanConverter
      when 'c' # for decimal
        DecimalConverter
      when 's', 'l', 'd' # for short, long, double
        IntegerConverter

#         when 'b' # for byte and binary

      when 'a' # for date
        DateConverter
      when 't' # for datetime
        DateTimeConverter
      when 'e' # for Set, because arrays and List are serialized as arrays like [3,4,5]
        SetConverter
      when 'x' # for links
        RID
      when 'n' # for linksets
        LinkSetCoercer
      when 'z' # for linklist
        LinkListCoercer

#         when 'm' # for linkmap
#         when 'g' # for linkbag

      else
        @field_types[key]
      end
    end

    ##
    # Transform...
    def self.call(value)
      case value
      when String
        parse(value)
      when Hash
        new(value)
      else
        new()
      end
    end

    def self.parse(value)
      types = value.present? ? value.split(',').map { |v| v.split('=') }.to_h : nil
      new(types)
    end

  end
end
end