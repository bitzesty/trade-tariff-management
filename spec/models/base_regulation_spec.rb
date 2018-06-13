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
          base_regulation = create :base_regulation,
                                   officialjournal_page: 11
          base_regulation.officialjournal_page = 12
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_truthy
        end

        it "invalid" do
          base_regulation = create :base_regulation,
                                   information_text: "AB"
          base_regulation.information_text = "AC"
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_falsey
        end
      end
    end

    context "ROIMB6" do
      describe "allow certain fields to be modified when regulation is abrogated" do
        it "valid" do
          base_regulation = create :base_regulation,
                                   :abrogated,
                                   officialjournal_page: 11
          base_regulation.officialjournal_page = 12
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_truthy
        end

        it "invalid" do
          base_regulation = create :base_regulation,
                                   :abrogated,
                                   information_text: "AB"
          base_regulation.information_text = "AC"
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_falsey
        end
      end
    end

    context "ROIMB48" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 effective_end_date: Date.today + 10.days
        base_regulation.validity_end_date = Date.today + 5.days
        expect(
          base_regulation.conformant_for?(:create)
        ).to be_truthy
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 effective_end_date: Date.today + 10.days
        base_regulation.validity_end_date = Date.today + 15.days
        expect(
          base_regulation.conformant_for?(:create)
        ).to be_falsey
      end
    end
  end
end
