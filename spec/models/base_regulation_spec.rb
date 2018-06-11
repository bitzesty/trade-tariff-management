require 'rails_helper'

describe BaseRegulation do
  describe 'validations' do
    # ROIMB1
    it { should validate_uniqueness.of([:base_regulation_id, :base_regulation_role])}
    # ROIMB3
    it { should validate_validity_dates }

    context "ROIMB4" do
      let(:base_regulation) {
        build(:base_regulation, regulation_group_id: regulation_group_id)
      }

      before { base_regulation.conformant? }

      describe "valid" do
        let(:regulation_group_id) { create(:regulation_group).regulation_group_id }
        it { expect(base_regulation.conformance_errors).to be_empty }
      end

      describe "invalid" do
        let(:regulation_group_id) { "ACC" }
        it {
          expect(base_regulation.conformance_errors).to have_key(:ROIMB4)
        }
      end
    end

    context "ROIMB5" do
      describe "allows specific fields to be modified" do
        it "valid" do
          base_regulation = create :base_regulation
          base_regulation.officialjournal_page = 12
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_truthy
        end

        it "invalid" do
          base_regulation = create :base_regulation,
                                   complete_abrogation_regulation_role: 8
          base_regulation.complete_abrogation_regulation_role = 9
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_falsey
        end
      end
    end
  end
end
