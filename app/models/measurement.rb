class Measurement < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:measurement_unit_code,
                               :measurement_unit_qualifier_code]
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code, :measurement_unit_qualifier_code]

  one_to_one :measurement_unit, key: :measurement_unit_code,
                                primary_key: :measurement_unit_code

  one_to_one :measurement_unit_qualifier, key: :measurement_unit_qualifier_code,
                                          primary_key: :measurement_unit_qualifier_code

  def record_code
    "220".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
