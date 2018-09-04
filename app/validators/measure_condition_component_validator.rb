class MeasureConditionComponentValidator < TradeTariffBackend::Validator

  validation :ME105, 'The reference duty expression must exist.', on: [:create, :update] do |record|
    record.duty_expression_id.present? &&
    record.duty_expression.present?
  end

  validation :ME106, 'The VP of the duty expression must span the VP of the measure.', on: [:create, :update] do
    validates :validity_date_span, of: :duty_expression
  end

  validation :ME109, "If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered.", on: [:create, :update] do |record|
    record.duty_expression_id.present? && %w[12 14 21 25 27 29 37 99].include?(record.duty_expression_id) && record.duty_amount.present?
  end

end
