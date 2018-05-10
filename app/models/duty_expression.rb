class DutyExpression < Sequel::Model

  include ::XmlGeneration::BaseHelper

  MEURSING_DUTY_EXPRESSION_IDS = %w[12 14 21 25 27 29]

  plugin :time_machine
  plugin :oplog, primary_key: :duty_expression_id
  plugin :conformance_validator

  set_primary_key [:duty_expression_id]

  one_to_one :duty_expression_description

  one_to_many :measure_components, key: :duty_expression_id,
                                   primary_key: :duty_expression_id

  one_to_many :measure_condition_components, key: :duty_expression_id,
                                             primary_key: :duty_expression_id

  delegate :abbreviation, :description, to: :duty_expression_description

  def record_code
    "230".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      duty_expression_id: duty_expression_id,
      abbreviation: abbreviation,
      description: description
    }
  end
end
