class MeasureExcludedGeographicalArea < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: [:measure_sid, :geographical_area_sid]
  plugin :conformance_validator

  set_primary_key [:measure_sid, :geographical_area_sid]

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :geographical_area, key: :geographical_area_sid,
                       primary_key: :geographical_area_sid

  delegate :validity_start_date, :validity_end_date, to: :geographical_area, allow_nil: true

  def record_code
    "430".freeze
  end

  def subrecord_code
    "15".freeze
  end

  def to_json(options = {})
    {
      geographical_area: geographical_area.to_json
    }
  end
end
