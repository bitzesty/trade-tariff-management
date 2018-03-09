class FootnoteDescriptionPeriod < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_id,
                               :footnote_type_id,
                               :footnote_description_period_sid]
  plugin :conformance_validator

  set_primary_key [:footnote_id, :footnote_type_id, :footnote_description_period_sid]

  one_to_one :footnote_description, key: [:footnote_id, :footnote_type_id,
                                          :footnote_description_period_sid]
  def record_code
    "200".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
