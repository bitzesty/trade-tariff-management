######### Conformance validations 215
class MeasurementUnitQualifierValidator < TradeTariffBackend::Validator
  validation :MUQ1, 'The measurement unit qualifier code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measurement_unit_qualifier_code]
  end

  validation :MUQ2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :MUQ3, 'If a measurement unit qualifier is used in a measure then the validity period of the measurement unit qualifier must span the validity period of the measure.' do |record|
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
    end

    if record.measure_conditions.any?
      s = record.measure_conditions.all? {|component|
        measure = component.measure

        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      }

      result = false unless s
    end

    result
  end

  validation :MUQ4, 'The measurement unit qualifier can not be deleted if it is used in a measure.', on: :destroy do |record|

    record.measure_components.any? || record.measure_condition_components.any? || record.measure_conditions.any?
  end
end
