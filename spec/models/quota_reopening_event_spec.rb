# frozen_string_literal: true

require "rails_helper"

describe QuotaReopeningEvent do
  describe "validations" do
    describe "conformance rules" do
      let!(:quota_reopening_event) { create :quota_reopening_event }

      describe "QRE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(quota_reopening_event).to be_conformant
        end

        it "should not run validation succssfully" do
          quota_reopening_event.quota_definition_sid = nil

          expect(quota_reopening_event).to_not be_conformant
          expect(quota_reopening_event.conformance_errors).to have_key(:QRE1)
        end
      end
    end
  end
end
