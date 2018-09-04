class MeasureComponentValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MC1, 'Duty expression id can not be blank.', on: [:create, :update] do
    validates :presence, of: :duty_expression_id
  end

  validation :ME109, "If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered.", on: [:create, :update] do |record|
    record.duty_expression_id.present? && %w[12 14 21 25 27 29 37 99].include?(record.duty_expression_id) && record.duty_amount.present?
  end

end
