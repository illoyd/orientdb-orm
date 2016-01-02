module Orientdb
module ORM
  class FieldType

    ##
    # Field types
    attr_reader :field_types
    
    delegate :[]=, to: :field_types

    ##
    # Create a new FieldType.
    def initialize(field_types={})
      field_types ||= {}
      @field_types = self.class.default_field_types.reverse_merge(field_types)
    end
    
    def self.default_field_types
      { '@rid' => RID, '@fieldTypes' => FieldType }
    end
    
    def merge!(other)
      other = @field_types.field_types if other === FieldType   
      @field_types.merge!(other)
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
      self[key].try(:call, value) || value.presence || nil
    end

    ##
    # Map
    def [](key)
      case @field_types[key].try(:strip)
      when FloatType # for float
        FloatConverter

#       when 'b' # for boolean
#         BooleanConverter

      when DecimalType # for decimal
        DecimalConverter
      when ShortType, LongType, DoubleType # for short, long, double
        IntegerConverter

#         when 'b' # for byte and binary

      when DateType
        DateConverter
      when DateTimeType
        DateTimeConverter
      when SetType
        SetConverter
      when LinkType
        RID
      when LinkSetType
        LinkSetCoercer
      when LinkListType, LinkBagType
        LinkListCoercer

#         when 'm' # for linkmap

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
      when FieldType
        value
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