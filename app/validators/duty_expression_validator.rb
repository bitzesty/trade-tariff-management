######### Conformance validations 230
class DutyExpressionValidator < TradeTariffBackend::Validator
  validation :DE1, 'The code of the duty expression must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:duty_expression_id]
  end

  validation :DE2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :DE3, 'If a duty expression is used in a measure than the validity period of the duty expression must span the validity period of the measure.' do |record|
    result = true

    if record.measure_components.any?
      s = record.measure_components.all? {|component|
        measure = component.measure

        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      }

      result = false unless s
    end

    if record.measure_condition_components.any?
      s = record.measure_condition_components.all? {|component|
        measure = component.measure_condition.measure

        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      }

      result = false unless s

      result
    end
  end

  validation :DE4, 'The duty expression can not be deleted if it is used in a measure.', on: :destroy do |record|
    record.measure_components.none? && record.measure_condition_components.none?
  end
end
