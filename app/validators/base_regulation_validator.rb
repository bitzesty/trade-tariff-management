######### Conformance validations 285
class BaseRegulationValidator < TradeTariffBackend::Validator
  validation :ROIMB1, 'The (regulation id + role id) must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:base_regulation_id, :base_regulation_role]
  end

  validation :ROIMB3, 'The start date must be less than or equal to the end date' do
    validates :validity_dates
  end

  validation :ROIMB4, 'The referenced regulation group must exist', on: [:create, :update] do |record|
    if record.regulation_group_id.present?
      RegulationGroup.where(regulation_group_id: record.regulation_group_id).any?
    end
  end

  validation :on_officialjournal_page, 'Official journal page should be a number', on: [:create, :update] do
    validates :integer, of: :officialjournal_page,
                        allow_nil: true,
                        allow_blank: true
  end

  validation :ROIMB5,
             'If the regulation is replaced, completely or partially, modification is allowed only on the fields "Publication Date", "Official journal Number", "Official journal Page" and "Regulation Group Id".',
             on: [:update] do |record|
    if record.column_changes.present?
      allowed_fields_to_change = [
        :publication_date,
        :officialjournal_page,
        :officialjournal_number,
        :regulation_group_id,
        :replacement_indicator
      ]

      record.column_changes.keys.all? do |key|
        allowed_fields_to_change.include?(key)
      end
    end
  end

  validation :ROIMB6,
             'If the regulation is abrogated, completely or explicitly, modification is allowed only on the fields "Publication Date", "Official journal Number", "Official journal Page" and "Regulation Group Id".',
             on: [:update] do |record|
    if record.complete_abrogation_regulation.present? || record.explicit_abrogation_regulation.present?
      allowed_fields_to_change = [
        :publication_date,
        :officialjournal_page,
        :officialjournal_number,
        :regulation_group_id,
        :complete_abrogation_regulation_id,
        :complete_abrogation_regulation_role,
        :explicit_abrogation_regulation_id,
        :explicit_abrogation_regulation_role
      ]

      record.column_changes.keys.all? do |key|
        allowed_fields_to_change.include?(key)
      end
    end
  end

  # TODO: ROIMB7

  validation :ROIMB48,
             'If the regulation has not been abrogated, the effective end date must be greater than or equal to the base regulation end date if it is explicit.',
             on: [:create, :update] do |record|
    return true if record.complete_abrogation_regulation.present? && record.explicit_abrogation_regulation.present?

    if record.effective_end_date.present? && record.validity_end_date.present?
      record.effective_end_date >= record.validity_end_date
    end
  end

  validation :ROIMB44,
             'The "Regulation Approved Flag" indicates for a draft regulation whether the draft is approved, i.e. the regulation is definitive apart from its publication (only the definitive regulation id and the O.J. reference are not yet known). A draft regulation (regulation id starts with a \'C\') can have its "Regulation Approved Flag" set to 0=\'Not Approved\' or 1=\'Approved\'. Its flag can only change from 0=\'Not Approved\' to 1=\'Approved\'. Any other regulation must have its "Regulation Approved Flag" set to 1=\'Approved\'.' do |record|
    if record.base_regulation_id.starts_with?("C")
      !record.column_changed?(:approved_flag) || (record.column_changes[:approved_flag][0] == false && record.column_changes[:approved_flag][1] == true)
    else
      record.approved_flag
    end
  end

  # TODO: ROIMB46
  # TODO: ROIMB47
  # TODO: ROIMB8
  # TODO: ROIMB9
  # TODO: ROIMB10
  # TODO: ROIMB11
  # TODO: ROIMB12
  # TODO: ROIMB13
  # TODO: ROIMB14
  # TODO: ROIMB15
  # TODO: ROIMB16
  # TODO: ROIMB17
  # TODO: ROIMB18
  # TODO: ROIMB19
  # TODO: ROIMB20
  # TODO: ROIMB21
  # TODO: ROIMB22
  # TODO: ROIMB23
  # TODO: ROIMB24
  # TODO: ROIMB25
  # TODO: ROIMB26
  # TODO: ROIMB27
  # TODO: ROIMB28
  # TODO: ROIMB29
  # TODO: ROIMB30
  # TODO: ROIMB31
  # TODO: ROIMB32
  # TODO: ROIMB33
  # TODO: ROIMB34
  # TODO: ROIMB35
  # TODO: ROIMB36
  # TODO: ROIMB37
  # TODO: ROIMB38
  # TODO: ROIMB39
  # TODO: ROIMB40
  # TODO: ROIMB41
  # TODO: ROIMB43
  # TODO: ROAC4
  # TODO: ROAC6
  # TODO: ROAC7
  # TODO: ROAC8
  # TODO: ROAC10
  # TODO: ROAE4
  # TODO: ROAE6
  # TODO: ROAE7
  # TODO: ROAE8
  # TODO: ROAE11
end
