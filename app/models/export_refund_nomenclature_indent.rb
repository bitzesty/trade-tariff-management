class ExportRefundNomenclatureIndent < Sequel::Model
  include ::XmlGeneration::BaseHelper

  plugin :time_machine, period_start_column: :export_refund_nomenclature_indents__validity_start_date,
                        period_end_column:   :export_refund_nomenclature_indents__validity_end_date
  plugin :oplog, primary_key: :export_refund_nomenclature_indents_sid
  plugin :conformance_validator

  set_primary_key [:export_refund_nomenclature_indents_sid]

  def number_indents
    number_export_refund_nomenclature_indents
  end

  def record_code
    "410".freeze
  end

  def subrecord_code
    "05".freeze
  end
end
