class BaseRegulation < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::RegulationDocumentContext

  plugin :oplog, primary_key: [:base_regulation_id, :base_regulation_role]
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:base_regulation_id, :base_regulation_role]

  include ::FormApiHelpers::RegulationSearch

  one_to_one :complete_abrogation_regulation, primary_key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role],
                                              key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]

  one_to_one :explicit_abrogation_regulation, key: [:explicit_abrogation_regulation_id,
                                                    :explicit_abrogation_regulation_role],
                                              primary_key: [:explicit_abrogation_regulation_id,
                                                    :explicit_abrogation_regulation_role]

  many_to_one :measure_partial_temporary_stops, primary_key: :measure_generating_regulation_id,
                                                key: :partial_temporary_stop_regulation_id

  many_to_one :regulation_group

  one_to_many :modification_regulations, primary_key: [:base_regulation_id,
                                                    :base_regulation_role],
                                              key: [:base_regulation_id,
                                                    :base_regulation_role]

  one_to_one :related_antidumping_regulation,
              class: :BaseRegulation,
              primary_key: [ :base_regulation_id, :base_regulation_role ],
              key: [ :related_antidumping_regulation_id, :antidumping_regulation_role ]

  one_to_many :generating_measures,
              class: :Measure,
              key: [:measure_generating_regulation_role, :measure_generating_regulation_id]

  one_to_many :justification_measures,
              class: :Measure,
              primary_key: [:justification_regulation_role, :justification_regulation_id],
              key: [:justification_regulation_role, :justification_regulation_id]


  def not_completely_abrogated?
    complete_abrogation_regulation.blank?
  end

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end

  def record_code
    "285".freeze
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
