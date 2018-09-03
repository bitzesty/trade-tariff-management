require 'rails_helper'

describe MeasureConditionComponent do
  describe 'associations' do
    describe 'duty expression' do
      it_is_associated 'one to one to', :duty_expression do
        let(:duty_expression_id) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit' do
      it_is_associated 'one to one to', :measurement_unit do
        let(:measurement_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'monetary unit' do
      it_is_associated 'one to one to', :monetary_unit do
        let(:monetary_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit qualifier' do
      it_is_associated 'one to one to', :measurement_unit_qualifier do
        let(:measurement_unit_qualifier_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'Conformance rules' do
      describe 'ME105' do
        describe "The reference duty expression must exist" do
          let!(:measure_condition_component) do
            create(:measure_condition_component,
                   duty_expression_id: DutyExpression::MEURSING_DUTY_EXPRESSION_IDS.sample
            )
          end

          it "valid" do
            expect(measure_condition_component).to be_conformant
          end

          it "invalid" do
            measure_condition_component.duty_expression_id = nil
            measure_condition_component.save

            expect(measure_condition_component).to_not be_conformant
            expect(measure_condition_component.conformance_errors).to have_key(:ME105)
          end
        end
      end
    end
  end
end
