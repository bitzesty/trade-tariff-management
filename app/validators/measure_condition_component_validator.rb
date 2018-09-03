class MeasureConditionComponentValidator < TradeTariffBackend::Validator

  validation :ME105, 'The reference duty expression must exist.', on: [:create, :update] do
    validates :presence, of: :duty_expression_id
  end
end
