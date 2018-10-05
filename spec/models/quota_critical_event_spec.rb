# frozen_string_literal: true

require "rails_helper"

describe QuotaCriticalEvent do
  describe "validations" do
    describe "conformance rules" do
      let!(:quota_critical_event) { create :quota_critical_event }

      describe "QCRE1: The quota definition SID must exist." do
        it "should run validation succssfully" do
          expect(quota_critical_event).to be_conformant
        end

        it "should not run validation succssfully" do
          quota_critical_event.quota_definition_sid = nil

          expect(quota_critical_event).to_not be_conformant
          expect(quota_critical_event.conformance_errors).to have_key(:QCRE1)
        end
      end
    end
  end
end

