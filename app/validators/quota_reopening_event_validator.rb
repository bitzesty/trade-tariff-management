# frozen_string_literal: true

class QuotaReopeningEventValidator < TradeTariffBackend::Validator
  validation :QRE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
end
