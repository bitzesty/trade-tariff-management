class MeursingSubheading < Sequel::Model
  plugin :oplog, primary_key: [:meursing_table_plan_id,
                               :meursing_heading_number,
                               :row_column_code,
                               :subheading_sequence_number]
  plugin :conformance_validator

  set_primary_key [:meursing_table_plan_id, :meursing_heading_number, :row_column_code,
                   :subheading_sequence_number]
  def record_code
    "330".freeze
  end

  def subrecord_code
    "00".freeze
  end
end
