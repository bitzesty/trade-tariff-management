# frozen_string_literal: true

require "rails_helper"

describe QuotaBalanceEvent do
  describe ".last" do
    let!(:balance_event1)    { create :quota_balance_event,
                                      occurrence_timestamp: 3.days.ago }
    let!(:balance_event2)    { create :quota_balance_event,
                                      occurrence_timestamp: 1.days.ago }
    let!(:balance_event3)    { create :quota_balance_event,
                                      occurrence_timestamp: 2.days.ago }

    it "should order items by desc occurrence_timestamp" do
      expect(described_class.last).to eq(balance_event2)
    end
  end

  describe ".status" do
    it "should return 'open' string" do
      expect(described_class.status).to eq("open")
    end
  end

  describe "validations" do
    describe "conformance rules" do
      let!(:balance_event) { create :quota_balance_event,
                             occurrence_timestamp: 3.days.ago }

      describe "QBAE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(balance_event).to be_conformant
        end

        it "should not run validation succssfully" do
          balance_event.quota_definition_sid = nil

          expect(balance_event).to_not be_conformant
          expect(balance_event.conformance_errors).to have_key(:QBAE1)
        end
      end
    end
  end
end
