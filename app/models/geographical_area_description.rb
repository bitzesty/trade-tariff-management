class GeographicalAreaDescription < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: [:geographical_area_description_period_sid,
                               :geographical_area_sid]
  plugin :conformance_validator

  set_primary_key [:geographical_area_description_period_sid, :geographical_area_sid]

  one_to_one :geographical_area, key: :geographical_area_sid,
                                 primary_key: :geographical_area_sid
  one_to_one :geographical_area_description_period, key: :geographical_area_description_period_sid,
                                                    primary_key: :geographical_area_description_period_sid

  dataset_module do
    def latest
      order(Sequel.desc(:operation_date))
    end
  end

  def record_code
    "250".freeze
  end

  def subrecord_code
    "10".freeze
  end
end
