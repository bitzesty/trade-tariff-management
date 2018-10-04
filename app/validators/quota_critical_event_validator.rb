# frozen_string_literal: true

class QuotaCriticalEventValidator < TradeTariffBackend::Validator
  validation :QCRE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
end
