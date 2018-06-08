######### Conformance validations 235
class MeasureTypeValidator < TradeTariffBackend::Validator
  validation :MT1, 'The  measure type code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measure_type_id]
  end

  validation :MT2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :MT3,
             'When a measure type is used in a measure then the validity period of the measure type must span the validity period of the measure.',
             on: [:create, :update] do |record|
    if record.measures.any?
      record.measures.all? {|measure|
        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      }
    end
  end

  validation :MT4, 'The referenced measure type series must exist.', on: [:create, :update] do
    validates :presence, of: :measure_type_series
  end
end
