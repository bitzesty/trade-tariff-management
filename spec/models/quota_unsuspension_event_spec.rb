# frozen_string_literal: true

require "rails_helper"

describe QuotaUnsuspensionEvent do
  describe "validations" do
    describe "conformance rules" do
      let!(:quota_unsuspension_event) { create :quota_unsuspension_event }

      describe "QUSE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(quota_unsuspension_event).to be_conformant
        end

        it "should not run validation succssfully" do
          quota_unsuspension_event.quota_definition_sid = nil

          expect(quota_unsuspension_event).to_not be_conformant
          expect(quota_unsuspension_event.conformance_errors).to have_key(:QUSE1)
        end
      end
    end
  end
end
