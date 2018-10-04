# frozen_string_literal: true

class QuotaUnblockingEventValidator < TradeTariffBackend::Validator
  validation :QUBLE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
end
