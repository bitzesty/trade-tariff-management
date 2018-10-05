# frozen_string_literal: true

require "rails_helper"

describe QuotaExhaustionEvent do
  describe "validations" do
    describe "conformance rules" do
      let!(:quota_exhaustion_event) { create :quota_exhaustion_event }

      describe "QEE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(quota_exhaustion_event).to be_conformant
        end

        it "should not run validation succssfully" do
          quota_exhaustion_event.quota_definition_sid = nil

          expect(quota_exhaustion_event).to_not be_conformant
          expect(quota_exhaustion_event.conformance_errors).to have_key(:QEE1)
        end
      end
    end
  end
end
