######### Conformance validations 220
class MeasurementValidator < TradeTariffBackend::Validator
  validation :MENT1, 'The combination measurement unit code + measurement unit qualifier must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measurement_unit_code, :measurement_unit_qualifier_code]
  end

  validation :MENT2, 'The associated measurement unit code must exist.' do
    validates_presence_of :measurement_unit
  end

  validation :MENT3, 'The associated measurement unit qualifier code must exist.' do
    validates_presence_of :measurement_unit
  end

  validation :MENT6, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
