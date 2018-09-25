class QuotaOrderNumber < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_id,
                                primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition)
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  one_to_many :parent_quota_associations, class: :QuotaAssociation,
                                         key: :main_quota_definition_sid,
                                         primary_key: :quota_order_number_sid

  one_to_many :sub_quota_associations, class: :QuotaAssociation,
                                      key: :sub_quota_definition_sid,
                                      primary_key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true

  dataset_module do
    def q_search(keyword)
      where {
        Sequel.ilike(:quota_order_number_id, "#{keyword}%")
      }
    end
  end

  def record_code
    "360".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      quota_order_number_id: quota_order_number_id
    }
  end
end
