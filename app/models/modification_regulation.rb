class ModificationRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::FormApiHelpers::RegulationSearch
  include ::RegulationDocumentContext

  plugin :oplog, primary_key: [:modification_regulation_id,
                               :modification_regulation_role]
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

  one_to_one :base_regulation, key: [:base_regulation_id, :base_regulation_role],
                               primary_key: [:base_regulation_id, :base_regulation_role]

  one_to_one :complete_abrogation_regulation, primary_key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role],
                                              key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]

  one_to_one :explicit_abrogation_regulation, key: [:explicit_abrogation_regulation_id,
                                                    :explicit_abrogation_regulation_role],
                                              primary_key: [:explicit_abrogation_regulation_id,
                                                    :explicit_abrogation_regulation_role]

  one_to_many :generating_measures,
              class: :Measure,
              key: [:measure_generating_regulation_role, :measure_generating_regulation_id]

  one_to_many :justification_measures,
              class: :Measure,
              primary_key: [:justification_regulation_role, :justification_regulation_id],
              key: [:justification_regulation_role, :justification_regulation_id]

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end

  def record_code
    "290".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def true_end_date
    effective_end_date || validity_end_date || nil
  end

  def abrogated?
    explicit_abrogation_regulation.present? || complete_abrogation_regulation.present?
  end
end
