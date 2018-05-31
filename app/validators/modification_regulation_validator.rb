######### Conformance validations 290
class ModificationRegulationValidator < TradeTariffBackend::Validator
  validation :ROIMM1, 'The (regulation id + role id) must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:modification_regulation_id, :modification_regulation_role]
  end

  validation :ROIMM5, 'The start date must be less than or equal to the end date if the end date is explicit.' do
    validates :validity_dates
  end

  validation :on_officialjournal_page, 'Official journal page should be a number', on: [:create, :update] do
    validates :integer, of: :officialjournal_page,
                        allow_nil: true,
                        allow_blank: true
  end

  validation :ROIMM3, 'A modification regulation must be related with a base regulation, which may not be a draft one (regulation id starts with a \'C\')' do |record|
    return false if record.base_regulation.blank?

    !record.base_regulation_id.starts_with?("C")
  end

  validation :ROIMM4, 'The insert is refused if the base regulation is completely abrogated.' do |record|
    return false if record.base_regulation.complete_abrogation_regulation.present?
  end

  validation :ROIMM6, 'The start date must fall within the validity period of its base regulation, taking into account prorogations and explicit abrogation.' do |record|
    record.base_regulation.validity_start_date <= record.validity_start_date &&
      (record.base_regulation.true_end_date.blank? || record.base_regulation.true_end_date >= record.validity_start_date)
  end

  validation :ROIMM7, 'The end date, when explicit, must fall within the validity period of its base regulation, taking into account prorogations and explicit abrogation.' do |record|
    if record.validity_end_date.present?
      record.base_regulation.validity_start_date >= record.validity_end_date &&
        ((record.base_regulation.true_end_date.blank? || record.validity_end_date.blank?) ||
          (record.base_regulation.true_end_date >= record.validity_end_date))
    end
  end

  validation :ROIMM8, 'If the regulation is replaced, completely or partially, modification is allowed only on the fields "Publication Date", "Official journal Number" and "Official journal Page".', on: [:update] do |record|
    allowed_fields = %w(published_date officialjournal_number officialjournal_page)

    if record.replacement_indicator != "0"
      return false if record.column_changes.keys.any? { |k| !allowed_fields.include?(k) }
    end
  end

  validation :ROIMM9, 'If the regulation is abrogated, completely or explicitly, modification is allowed only on the fields "Publication Date", "Official journal Number" and "Official journal Page".', on: [:update] do |record|
    allowed_fields = %w(published_date officialjournal_number officialjournal_page)

    if record.abrogated?
      return false if record.column_changes.keys.any? { |k| !allowed_fields.include?(k) }
    end
  end

  validation :ROIMM10, 'If the regulation is prorogated, modification is allowed only on the fields "Publication Date", "Official journal Number" and "Official journal Page".' do |record|
    # no-op. we don't have prorogation in the system.
  end

  validation :ROIMM11, 'If its base regulation is completely abrogated, modification is allowed only on the fields "Publication Date", "Official journal Number" and "Official journal Page".', on: [:update] do |record|
    allowed_fields = %w(published_date officialjournal_number officialjournal_page)

    if record.base_regulation.abrogated?
      return false if record.column_changes.keys.any? { |k| !allowed_fields.include?(k) }
    end
  end

  validation :ROIMM12, 'The end date cannot be changed from implicit to explicit if its base regulation is explicitly abrogated.' do |record|
    if record.base_regulation.explicit_abrogation_regulation.present?
       record.column_changed?(:validity_end_date) &&
         record.column_changes["validity_end_date"][0].nil? &&
         !record.column_changes["validity_end_date"][1].nil?
    end
  end

  validation :ROIMM13, 'The end date cannot be changed if it is explicit and greater than the abrogation date of its base regulation. This can happen when the modification regulation was created first, and the base regulation was explicitly abrogated later.' do |record|
    if record.base_regulation.abrogated?
      return false if record.column_changed?(:validity_end_date) &&
         !record.column_changes["validity_end_date"][0].nil? &&
         record.column_changes["validity_end_date"][0] >= record.base_regulation.true_end_date
    end
  end

  validation :ROIMM34, 'The "Regulation Approved Flag" indicates for a draft regulation whether the draft is approved, i.e. the regulation is definitive apart from its publication (only the definitive regulation id and the O.J. reference are not yet known). A draft regulation (regulation id starts with a \'C\') can have its "Regulation Approved Flag" set to 0=\'Not Approved\' or 1=\'Approved\'. Its flag can only change from  0=\'Not Approved\' to 1=\'Approved\'. Any other regulation must have its "Regulation Approved Flag" set to 1=\'Approved\'.' do |record|
    if record.base_regulation_id.starts_with?("C")
      !record.column_changed?(:approved_flag) || (record.column_changes["approved_flag"][0] == false && record.column_changes["approved_flag"][1] == true)
    else
      record.approved_flag?
    end
  end

  validation :ROIMM35, 'A modification regulation cannot be deleted if it is used as a justification regulation, except for ‘C’ regulations used only in measures as both measure-generating regulation and justification regulation. Since the justification regulation in a measure has no associated role type id , this rule needs to be checked only if there are no other base or modification regulations with the same regulation id and approved status, which cover at least the same validity period as the base regulation to be deleted.', on: [:destroy] do |record|
    if record.modification_regulation_id.starts_with?("C")
      if record.justification_measures.any?
        record.justification_measures.all? do |measure|
          measure.generating_regulation == measure.justification_regulation
        end
      end
    else
      record.justification_measures.empty?
    end
  end

  validation :ROIMM36, 'If the regulation has not been abrogated, the effective end date must be greater than or equal to the modification regulation end date if it is explicit.' do |record|
    if record.effective_end_date.present? && !record.abrogated?
      record.effective_end_date >= record.validity_end_date
    end
  end

  validation :ROIMM14, 'Explicit dates of related measures must be within the validity period of the modification regulation.' do |record|
    return false unless record.justification_measures.all? do |measure|
      record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
    end

    return false unless record.generating_measures.all? do |measure|
      record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
    end
  end

  validation :ROIMM16, 'The measures must not overlap with measures on the same or hierarchical level. Apply the rule when changing the start date further back in time or when changing the end date further forward in time.' do |record|

  end

  validation :ROIMM17, 'The start date of the first PTS in time must be within the validity period of the base regulation. Apply the rule when changing the start date further forward in time.' do |record|

  end

  validation :ROIMM18, 'The start date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is implicit. Apply the rule when changing the end date further back in time.' do |record|

  end

  validation :ROIMM19, 'The end date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is explicit. Apply the rule when changing the end date further back in time.' do |record|

  end

  validation :ROIMM20, 'Ignore complete abrogated regulations.' do |record|

  end

  validation :ROIMM21, 'The start date of the first FTS in time must be within the validity period of the modification regulation.' do |record|
    if record.full_temporary_stop_regulations.any?
      record.full_temporary_stop_regulations.first.validity_start_date >= record.validity_start_date &&
        record.full_temporary_stop_regulations.first.validity_start_date <= record.validity_end_date
    end
  end

  validation :ROIMM22, 'The start date of the last FTS in time must be within the validity period of the modification regulation if the FTS end date is implicit.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.validity_end_date.blank?
      record.full_temporary_stop_regulations.last.validity_start_date >= record.validity_start_date && record.full_temporary_stop_regulations.last.validity_start_date <= record.validity_end_date
    end
  end

  validation :ROIMM23, 'The end date of the last FTS in time must be within the validity period of the modification regulation if the FTS end date is explicit.' do |record|
    if record.full_temporary_stop_regulations.any?
      record.full_temporary_stop_regulations.last.validity_end_date >= record.validity_start_date && record.full_temporary_stop_regulations.last.validity_end_date <= record.validity_end_date
    end
  end

  validation :ROIMM24, 'The abrogation date of the last FTS in time must be within the validity period of the modification regulation if the FTS regulation is explicitly abrogated.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.explicit_abrogation_regulation.present?
      record.full_temporary_stop_regulations.last.effective_enddate >= record.validity_start_date &&
        record.full_temporary_stop_regulations.last.effective_enddate <= record.validity_end_date
    end
  end

  validation :ROIMM25, 'A modification regulation cannot be deleted if it is abrogated.', on: [:destroy] do |record|
    !record.abrogated?
  end

  validation :ROIMM26, 'A modification regulation cannot be deleted if it is fully temporary stopped.', on: [:destroy] do |record|
    if record.full_temporary_stop_regulations.any?
      fts = record.full_temporary_stop_regulations.last

      return false if fts.validity_start_date <= Date.today && (fts.validity_end_date.blank? || fts.validity_end_date >= Date.today)
    end
  end

  validation :ROIMM27, 'A modification regulation cannot be deleted if it is replaced (completely or partially)', on: [:destroy] do |record|
    record.replacement_indicator == "0"
  end

  validation :ROIMM28, 'A modification regulation cannot be deleted if it is replacing another regulation (completely or partially).', on: [:destroy] do |record|

  end

  validation :ROIMM29, 'A modification regulation cannot be deleted if the regulation is not a draft one (regulation id starts with a \'C\') and has related measures.', on: [:destroy] do |record|
    return false if !record.modification_regulation_id.starts_with?("C") &&
                      ( record.justification_measures.any? || record.generating_measures.any? )
  end

  validation :ROIMM30, 'When the regulation is a draft one (regulation id starts with 'C') and it has related measures, the system must ask for confirmation to proceed. When confirmed, the system can delete the measures and eventually the regulation.' do |record|

  end

  validation :ROAC4, 'The abrogation regulation may not be replaced.' do |record|
    (record.explicit_abrogation_regulation.present? &&
      record.explicit_abrogation_regulation.replacement_indicator > 0) ||
    (record.complete_abrogation_regulation.present? &&
      record.complete_abrogation_regulation.replacement_indicator > 0)
  end

  validation :ROAC6, 'The modification regulation may not be a draft regulation (regulation id starts with 'C')' do |record|
    return false if record.explicit_abrogation_regulation.present? &&
      record.modification_regulation_id.starts_with?("C")
  end

  validation :ROAC7, 'The modification regulation may not be abrogated.' do |record|
    record.abrogated? && !record.base_regulation.abrogated?
  end

  validation :ROAC9, 'A modification regulation cannot be abrogated if its related base regulation is completely abrogated.' do |record|
    if record.base_regulation.abrogated?
  end

  validation :ROAC10, 'When the abrogation for a modification regulation is deleted, all related measures must be re-validated.' do |record|
    if record.column_changed?(:complete_abrogation_regulation_id)
      if !record.column_changes["complete_abrogation_regulation_id"][0].nil? && record.column_changes["complete_abrogation_regulation_id"][1].nil?
        return false if record.justification_measures.any? { |m| !m.valid? }
        return false if record.generating_measures.any? { |m| !m.valid? }
      end
    end

    if record.column_changed?(:explicit_abrogation_regulation_id)
      if !record.column_changes["explicit_abrogation_regulation_id"][0].nil? && record.column_changes["explicit_abrogation_regulation_id"][1].nil?
        return false if record.justification_measures.any? { |m| !m.valid? }
        return false if record.generating_measures.any? { |m| !m.valid? }
      end
    end
  end

  validation :ROAC11, 'When the abrogation for a modification regulation is deleted, its validity period must fall within the validity period of its base regulation.' do |record|
    if record.column_changed?(:complete_abrogation_regulation_id)
      if !record.column_changes["complete_abrogation_regulation_id"][0].nil? && record.column_changes["complete_abrogation_regulation_id"][1].nil?
        return false unless record.base_regulation.validity_start_date <= record.validity_start_date &&
          (record.base_regulation.true_end_date.blank? ||
          (record.validity_end_date.blank? && record.base_regulation.true_end_date >= record.validity_end_date))
      end
    end

    if record.column_changed?(:explicit_abrogation_regulation_id)
      if !record.column_changes["explicit_abrogation_regulation_id"][0].nil? && record.column_changes["explicit_abrogation_regulation_id"][1].nil?
        return false unless record.base_regulation.validity_start_date <= record.validity_start_date &&
          (record.base_regulation.true_end_date.blank? ||
          (record.validity_end_date.blank? && record.base_regulation.true_end_date >= record.validity_end_date))
      end
    end
  end

  validation :ROAC16, 'When a modification regulation is completely abrogated, then there may be no measures which are generated by another regulation and have the modification regulation as the justification regulation.' do |record|
    if record.complete_abrogation_regulation.present?
      record.justification_measures.all? do |measure|
        measure.generating_regulation != record
      end
    end
  end

  validation :ROAE4, 'The abrogation regulation may not be replaced.' do |record|

  end

  validation :ROAE6, 'The modification regulation may not be a draft regulation (regulation id starts with 'C')' do |record|
    return false if modification_regulation_id.starts_with?("C")
  end

  validation :ROAE7, 'The modification regulation may not be abrogated completely or explicitly.' do |record|
    !record.abrogated?
  end

  validation :ROAE9, 'The modification regulation cannot be abrogated if its related base regulation is completely abrogated.' do |record|
    return false if record.base_regulation.abrogated? && record.abrogated?
  end

  validation :ROAE11, 'The effective end date must be greater than or equal to the modification regulation start date. The effective end date must be less than the modification regulation end date if it is explicit.' do |record|
    if record.abrogated?
      return false if record.effective_end_date < record.validity_start_date

      if record.explicit_abrogation_regulation.present?
        return false if record.effective_end_date >= record.validity_end_date
      end
    end
  end

  validation :ROAE12, 'The effective end date must be less than the related base end date, taking into account prorogations and explicit abrogation, if the modification end date is implicit.' do |record|
    if record.validity_end_date.blank? && record.effective_end_date.present?
      return false if record.effective_end_date >= record.base_regulation.true_end_date
    end
  end

  validation :ROAE19, 'When a modification regulation is explicitly abrogated, then there may be no measures which are generated by another regulation and have the modification regulation as the justification regulation with an end date greater than the effective end date.' do |record|
    if record.explicit_abrogation_regulation.present?
      record.justification_measures.all? do |measure|
        measure.generating_regulation != record &&
          (measure.validity_end_date.blank? || measure.validity_end_date <= record.true_end_date)
      end
    end
  end

end
