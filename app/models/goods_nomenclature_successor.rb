class GoodsNomenclatureSuccessor < Sequel::Model
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :oplog, primary_key: %i[goods_nomenclature_sid
                                 absorbed_goods_nomenclature_item_id
                                 absorbed_productline_suffix
                                 goods_nomenclature_item_id
                                 productline_suffix]
  plugin :conformance_validator

  set_primary_key %i[goods_nomenclature_sid absorbed_goods_nomenclature_item_id
                     absorbed_productline_suffix goods_nomenclature_item_id
                     productline_suffix]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
  many_to_one :absorbed_goods_nomenclature, primary_key: %i[goods_nomenclature_item_id
                                                            producline_suffix],
                                           key: %i[absorbed_goods_nomenclature_item_id
                                                   absorbed_productline_suffix],
                                           class: 'GoodsNomenclature'

  def record_code
    "400".freeze
  end

  def subrecord_code
    "40".freeze
  end
end
