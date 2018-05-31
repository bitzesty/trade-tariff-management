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

  validation :ROIMB5, 'If the regulation is replaced, completely or partially, modification is allowed only on the fields "Publication Date", "Official journal Number", "Official journal Page" and "Regulation Group Id".', on: [:update] do |record|
    if record.replacement_indicator > 0
      allowed_fields_to_change = [
        :publication_date,
        :officialjournal_page,
        :officialjournal_number,
        :regulation_group_id,
        :replacement_indicator
      ]

      record.column_changes.all? { |f| allowed_fields_to_change.include?(f) }
    end
  end

  validation :ROIMB6, 'If the regulation is abrogated, completely or explicitly, modification is allowed only on the fields "Publication Date", "Official journal Number", "Official journal Page" and "Regulation Group Id".', on: [:update] do
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

      record.column_changes.all? { |f| allowed_fields_to_change.include?(f) }
    end
  end

  validation :ROIMB7, 'If the regulation is prorogated, modification is allowed only on the fields "Publication Date", "Official journal Number", "Official journal Page" and "Regulation Group Id".', on: [:update] do |record|

  end

  validation :ROIMB48, 'If the regulation has not been abrogated, the effective end date must be greater than or equal to the base regulation end date if it is explicit.', on: [:create, :update] do |record|
    return true if record.complete_abrogation_regulation.present? && record.explicit_abrogation_regulation.present?

    if record.effective_end_date.present? && record.validity_end_date.present?
      record.effective_end_date >= record.validity_end_date
    end
  end

  validation :ROIMB44, 'The "Regulation Approved Flag" indicates for a draft regulation whether the draft is approved, i.e. the regulation is definitive apart from its publication (only the definitive regulation id and the O.J. reference are not yet known). A draft regulation (regulation id starts with a \'C\') can have its "Regulation Approved Flag" set to 0=\'Not Approved\' or 1=\'Approved\'. Its flag can only change from 0=\'Not Approved\' to 1=\'Approved\'. Any other regulation must have its "Regulation Approved Flag" set to 1=\'Approved\'.' do |record|
    if record.base_regulation_id.starts_with?("C")
      !record.column_changed?(:approved_flag) || (record.column_changes["approved_flag"][0] == false && record.column_changes["approved_flag"][1] == true)
    else
      record.approved_flag?
    end
  end

  validation :ROIMB46, 'A base regulation cannot be deleted if it is used as a justification regulation, except for ‘C’ regulations used only in measures as both measure-generating  regulation and justification regulation.', on: [:destroy] do |record|

  end


  validation :ROIMB47, 'The validity period of the regulation group id must span the validity period of the base regulation.', on: [:create, :update] do
    if record.regulation_group.present?
      record.regulation_group.validity_start_date <= record.validity_start_date &&
        ((record.regulation_group.validity_end_date.blank? || record.validity_end_date.blank?) ||
          (record.regulation_group.validity_end_date >= record.validity_end_date))
    end
  end

  validation :ROIMB8, 'Explicit dates of related measures must be within the validity period of the base regulation.' do |record|
    if record.generating_measures.any?
      record.generating_measures.all? do |measure|
        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      end
    end
  end

  # TODO: ROIMB9
  # TODO: ROIMB10

  validation :ROIMB11, 'The start date of the first PTS in time must be within the validity period of the base regulation. Apply the rule when changing the start date further forward in time.' do |record|
    if record.generating_measures.any?
      record.generating_measures.all? do |measure|
        return true if measure.measure_partial_temporary_stops
      end
    end
  end

  validation :ROIMB12, 'The start date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is implicit. Apply the rule when changing the end date further back in time.' do |record|

  end

  validation :ROIMB13, 'The end date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is explicit. Apply the rule when changing the end date further back in time.' do |record|

  end

  # TODO: ROIMB14

  validation :ROIMB15, 'The validity period must span the start date of all related modification regulations.' do |record|
    record.modification_regulations.all? do |regulation|
      regulation.validity_start_date >= record.validity_start_date && regulation.true_end_date <= record.true_end_date
    end
  end

  validation :ROIMB16, 'The validity period must span explicit end dates of related modification regulations, taking into account prorogations and explicit abrogation.' do |record|

  end

  validation :ROIMB17, 'The validity period must span the abrogation date if the related modification regulation is explicitly abrogated. If the regulation is explicitly abrogated, ignore it for further validation.' do |record|

  end

  validation :ROIMB18, 'Ignore complete abrogated regulations.' do |record|

  end

  validation :ROIMB19, 'The start date of the last FTS in time must be within the validity period of the base regulation if the FTS end date is implicit.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.validity_end_date.blank?
      record.full_temporary_stop_regulations.last.validity_start_date >= record.validity_start_date &&
        record.full_temporary_stop_regulations.last.validity_start_date <= record.validity_end_date
    end
  end

  validation :ROIMB20, 'The end date of the last FTS in time must be within the validity period of the base regulation if the FTS end date is explicit.' do |record|
    if record.full_temporary_stop_regulations.any?
      record.full_temporary_stop_regulations.last.validity_end_date >= record.validity_start_date &&
        record.full_temporary_stop_regulations.last.validity_end_date <= record.validity_end_date
    end
  end

  validation :ROIMB21, 'The abrogation date of the last FTS in time must be within the validity period of the base regulation if the FTS regulation is explicitly abrogated.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.explicit_abrogation_regulation.present?
      record.full_temporary_stop_regulations.last.effective_enddate >= record.validity_start_date &&
        record.full_temporary_stop_regulations.last.effective_enddate <= record.validity_end_date
    end
  end

  validation :ROIMB22, 'Explicit dates of related measures must be within the validity period of the base regulation. Apply the rule when changing the end date further back in time.' do |record|
    if record.column_changed?(:validity_end_date) && record.column_changes[:validity_end_date][0] > record.column_changes[:validity_end_date][1]
      return false if !record.modification_regulations.all? do |regulation|
        record.validity_start_date <= regulation.validity_start_date &&
          ((record.validity_end_date.blank? || regulation.validity_end_date.blank?) ||
            (record.validity_end_date >= regulation.validity_end_date))
      end

      return false if !record.full_temporary_stop_regulations.all? do |regulation|
        record.validity_start_date <= regulation.validity_start_date &&
          ((record.validity_end_date.blank? || regulation.validity_end_date.blank?) ||
            (record.validity_end_date >= regulation.validity_end_date))
      end
    end
  end

  validation :ROIMB23, 'The start date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is implicit. Apply the rule when changing the end date further back in time.' do |record|
    # I don't think we have PTS in the system, other than MEASURE PTS.
    #TODO: check
  end

  validation :ROIMB24, 'The end date of the last PTS in time must be within the validity period of the base regulation if the PTS end date is explicit. Apply the rule when changing the end date further back in time.' do |record|
    # I don't think we have PTS in the system, other than MEASURE PTS.
    #TODO: check
  end

  # TODO: ROIMB25
  # TODO: ROIMB26
  # TODO: ROIMB27

  validation :ROIMB28, 'The start date of the first FTS in time must be within the validity period of the base regulation.' do |record|
    if record.full_temporary_stop_regulations.any?
      record.full_temporary_stop_regulations.first.validity_start_date >= record.validity_start_date &&
        record.full_temporary_stop_regulations.first.validity_start_date <= record.validity_end_date
    end
  end

  validation :ROIMB29, 'The start date of the last FTS in time must be within the validity period of the base regulation if the FTS end date is implicit.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.validity_end_date.blank?
      record.full_temporary_stop_regulations.last.validity_start_date >= record.validity_start_date && record.full_temporary_stop_regulations.last.validity_start_date <= record.validity_end_date
    end
  end

  validation :ROIMB30, 'The end date of the last FTS in time must be within the validity period of the base regulation if the FTS end date is explicit.' do |record|
    if record.full_temporary_stop_regulations.any?
      record.full_temporary_stop_regulations.last.validity_end_date >= record.validity_start_date && record.full_temporary_stop_regulations.last.validity_end_date <= record.validity_end_date
    end
  end

  validation :ROIMB31, 'The abrogation date of the last FTS in time must be within the validity period of the base regulation if the FTS regulation is explicitly abrogated.' do |record|
    if record.full_temporary_stop_regulations.any? && record.full_temporary_stop_regulations.last.explicit_abrogation_regulation.present?
      record.full_temporary_stop_regulations.last.effective_enddate >= record.validity_start_date &&
        record.full_temporary_stop_regulations.last.effective_enddate <= record.validity_end_date
    end
  end

  validation :ROIMB32, 'The provisional anti-dumping regulation may not be abrogated, completely or explicitly when creating the relationship.' do |record|
    if record.related_antidumping_regulation.present? && record.antidumping_regulation_role == '2'
      return false if record.related_antidumping_regulation.complete_abrogation_regulation.present? || record.related_antidumping_regulation.explicit_abrogation_regulation.present?
    end
  end

  validation :ROIMB33, 'The definitive anti-dumping regulation may not be completely abrogated when creating the relationship.' do |record|
    if record.related_antidumping_regulation.present? && record.antidumping_regulation_role == '3'
      return false if record.related_antidumping_regulation.complete_abrogation_regulation.present?
    end
  end

  validation :ROIMB34, 'The validity periods of the two regulations must be contiguous, taking into account prorogations for the provisional anti-dumping regulation.' do |record|
    if record.related_antidumping_regulation.present? && record.antidumping_regulation_role == '2'
      if record.validity_start_date > record.related_antidumping_regulation.validity_start_date
        # 1 day difference
        record.related_antidumping_regulation.validity_start_date - record.validity_end_date == 1
      else
        record.validity_start_date - record.related_antidumping_regulation.validity_end_date == 1
      end
    end
  end

  validation :ROIMB35, 'A base regulation cannot be deleted if it is abrogated.', on: [:destroy] do |record|
    return false if record.complete_abrogation_regulation.present? || record.explicit_abrogation_regulation.present?
  end

  validation :ROIMB36, 'A base regulation cannot be deleted if it is fully temporary stopped.', on: [:destroy] do |record|
    if record.full_temporary_stop_regulations.any?
      fts = record.full_temporary_stop_regulations.last

      return false if fts.validity_start_date <= Date.today && (fts.validity_end_date.blank? || fts.validity_end_date >= Date.today)
    end
  end

  validation :ROIMB37, 'A base regulation cannot be deleted if it is replaced (completely or partially)', on: [:destroy] do |record|
    record.replacement_indicator == 0
  end

  validation :ROIMB38, 'A base regulation cannot be deleted if it is replacing another regulation (completely or partially).', on: [:destroy] do |record|
    record.related_antidumping_regulation.blank? || record.related_antidumping_regulation.replacement_indicator == 0
  end

  validation :ROIMB39, 'A base regulation cannot be deleted if it is related with a modification regulation.', on: [:destroy] do |record|
    record.modification_regulations.none?
  end

  validation :ROIMB40, 'A base regulation cannot be deleted if it is used in a relationship provisional anti-dumping or definitive anti-dumping.', on: [:destroy] do |record|
    return false if record.related_antidumping_regulation.present?
  end

  validation :ROIMB41, 'A base regulation cannot be deleted if the regulation is not a draft one (regulation id starts with a \'C\') and has related measures.', on: [:destroy] do |record|
    !record.base_regulation_id.starts_with?("C") && record.generating_measures.any?
  end

  validation :ROIMB43, 'A base regulation cannot be deleted if it is prorogated.', on: [:destroy] do |record|
    # we don't have prorogation regulations in the app
  end

  validation :ROAC4, 'The abrogation regulation may not be replaced. ' do |record|
    record.complete_abrogation_regulation.blank || record.complete_abrogation_regulation.replacement_indicator == 0
  end

  validation :ROAC6, 'The base regulation may not be a draft regulation (regulation id starts with \'C\')' do |record|
    return false if record.base_regulation_id.starts_with?("C") && record.complete_abrogation_regulation.present?
  end

  validation :ROAC7, 'The base regulation may not be abrogated.' do |record|

  end

  validation :ROAC8, 'A provisional anti-dumping regulation cannot be abrogated if it is related with a definitive anti-dumping regulation, which is not completely abrogated. ' do |record|

  end

  validation :ROAC10, ' When the abrogation for a base regulation is deleted, all related measures must be re-validated.' do |record|
    # why is this validation in the base regulation class?
  end

  validation :ROAE4, 'The abrogation regulation may not be replaced.' do |record|

  end

  validation :ROAE6, 'The base regulation may not be a draft regulation (regulation id starts with \'C\') Rules when a base regulation is explicitly abrogated.' do |record|
    return false if record.base_regulation_id.starts_with?("C") && record.explicit_abrogation_regulation.present?
  end

  validation :ROAE7, 'The base regulation may not be abrogated completely or explicitly.' do |record|

  end

  validation :ROAE8, 'A provisional anti-dumping regulation cannot be abrogated if it is related with a definitive anti-dumping regulation, which is not completely abrogated.' do |record|

  end

  validation :ROAE11, ' The effective end date must be greater than or equal to the base regulation start date. The effective end date must be less than the base regulation end date if it is explicit.' do |record|

  end
end
