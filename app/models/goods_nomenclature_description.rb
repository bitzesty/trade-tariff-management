class GoodsNomenclatureDescription < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: %i[goods_nomenclature_sid
                                 goods_nomenclature_description_period_sid]
  plugin :conformance_validator

  set_primary_key %i[goods_nomenclature_sid goods_nomenclature_description_period_sid]

  one_to_one :goods_nomenclature, primary_key: :goods_nomenclature_sid, key: :goods_nomenclature_sid

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description

  def formatted_description
    super.mb_chars.downcase.to_s.gsub(/^(.)/) { $1.capitalize }
  end

  def to_s
    description
  end

  def record_code
    "400".freeze
  end

  def subrecord_code
    "15".freeze
  end
end
