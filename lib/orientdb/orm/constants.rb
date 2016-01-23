module Orientdb
  module ORM

    ##
    # Date time and timestamp field type
    DateTimeType = 't'.freeze

    ##
    # Date field type
    DateType = 'a'.freeze

    ##
    # Float field type
    FloatType = 'f'.freeze

    ##
    # Decimal field type
    DecimalType = 'c'.freeze

    ##
    # Decimal field type
    ShortType = 's'.freeze

    ##
    # Decimal field type
    LongType = 'l'.freeze

    ##
    # Decimal field type
    DoubleType = 'd'.freeze

    ##
    # Decimal field type
    SetType = 'e'.freeze

    ##
    # Link field type
    LinkType = 'x'.freeze

    ##
    # Link Set field type
    LinkSetType = 'n'.freeze

    ##
    # Link List field type
    LinkListType = 'z'.freeze

    ##
    # Link Bag / RID Bag field type
    LinkBagType = 'g'.freeze

    ##
    # Link Map field type
    LinkMapType = 'm'.freeze

    ##
    # Collection of all types for ease of reference
    Types = [
      Orientdb::ORM::ShortType,
      Orientdb::ORM::LongType,
      Orientdb::ORM::DoubleType,
      Orientdb::ORM::FloatType,
      Orientdb::ORM::DecimalType,
      Orientdb::ORM::DateType,
      Orientdb::ORM::DateTimeType,
      Orientdb::ORM::SetType,
      Orientdb::ORM::LinkType,
      Orientdb::ORM::LinkSetType,
      Orientdb::ORM::LinkListType,
      Orientdb::ORM::LinkMapType
    ]

  end
end