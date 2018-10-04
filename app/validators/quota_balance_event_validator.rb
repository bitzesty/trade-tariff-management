class QuotaBalanceEventValidator < TradeTariffBackend::Validator

  validation :QBAE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
  
end
