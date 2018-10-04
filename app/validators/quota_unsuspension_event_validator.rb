# frozen_string_literal: true
#
class QuotaUnsuspensionEventValidator < TradeTariffBackend::Validator
  validation :QUSE1, "The quota definition SID must exist.",
    on: [:create, :update] do
    validates :presence, of: :quota_definition_sid
  end
end
