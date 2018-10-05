# frozen_string_literal: true

require "rails_helper"

describe QuotaUnblockingEvent do
  describe "validations" do
    describe "conformance rules" do
      let!(:quota_unblocking_event) { create :quota_unblocking_event }

      describe "QUBLE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(quota_unblocking_event).to be_conformant
        end

        it "should not run validation succssfully" do
          quota_unblocking_event.quota_definition_sid = nil

          expect(quota_unblocking_event).to_not be_conformant
          expect(quota_unblocking_event.conformance_errors).to have_key(:QUBLE1)
        end
      end
    end
  end
end
