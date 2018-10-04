# frozen_string_literal: true

class QuotaExhaustionEventValidator < TradeTariffBackend::Validator
  validation :QEE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
end
