module Orientdb
  module ORM
    FloatConverter    = ->(value){ Float(value) rescue nil }
    DecimalConverter  = ->(value){ Decimal.new(value) }
    IntegerConverter  = ->(value){ Integer(value) rescue nil }
    SetConverter      = ->(value){ Set.new(value) rescue Set.new }
    DateConverter     = ->(value){ Date.parse(value) }
    DateTimeConverter = ->(value){ DateTime.parse(value) }
    BooleanConverter  = ->(value){ value == true || (value.to_s =~ /^(true|t|yes|y|1)$/i).present? }
  
    LinkListCoercer   = ->(value){ value.map{ |rid| RID.call(rid) } }
    LinkSetCoercer    = ->(value){ Set.new( LinkListCoercer.call(value) ) }
  end
end