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
  end

  describe 'Conformance rules' do
    let!(:measure)           { create :measure }
    let!(:measure_condition) { create :measure_condition, measure_sid: measure.measure_sid }
    let(:duty_expression_id) { DutyExpression::MEURSING_DUTY_EXPRESSION_IDS.sample }

    let!(:duty_expression)   do
      create(:duty_expression,
             duty_expression_id: duty_expression_id,
             duty_amount_applicability_code: 1,
             monetary_unit_applicability_code: 1,
             measurement_unit_applicability_code: 1
            )
    end

    let!(:measure_condition_component) do
      create(:measure_condition_component,
             measure_condition_sid: measure_condition.measure_condition_sid,
             duty_expression_id: duty_expression.duty_expression_id
            )
    end

    it "valid" do
      expect(measure_condition_component).to be_conformant
    end

    it "ME105: The reference duty expression must exist" do
      measure_condition_component.duty_expression_id = nil
      measure_condition_component.save

      expect(measure_condition_component).to_not be_conformant
      expect(measure_condition_component.conformance_errors).to have_key(:ME105)
    end

    it "ME106: The VP of the duty expression must span the VP of the measure." do
      measure.validity_start_date = Date.today.ago(5.years)
      measure.validity_end_date = Date.today.ago(4.years)
      measure.save

      expect(measure_condition_component).to_not be_conformant
      expect(measure_condition_component.conformance_errors).to have_key(:ME106)
    end

    describe "Flag 'amount' on duty expression is mandatory" do
      it "ME109: If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered." do
        measure_condition_component.duty_amount = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME109)

      end
    end

    describe "Flag 'amount' on duty expression is not permitted" do
      it "ME109: If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered." do
        duty_expression.duty_amount_applicability_code = 2
        duty_expression.save

        measure_condition_component.duty_amount = 3.0
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME109)
      end
    end

    describe "Flag 'monetary unit' on duty expression is mandatory" do
      it "ME110: If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered." do
        duty_expression.monetary_unit_applicability_code = 1
        duty_expression.save

        measure_condition_component.monetary_unit_code = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME110)
      end
    end

    describe "Flag 'monetary unit' on duty expression is not permitted" do
      it "ME110: If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered." do
        duty_expression.monetary_unit_applicability_code = 2
        duty_expression.save

        measure_condition_component.monetary_unit_code = 'BGN'
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME110)
      end
    end

    describe "Flag 'measurement unit' on duty expression is mandatory" do
      it "ME111: If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered." do
        duty_expression.measurement_unit_applicability_code = 1
        duty_expression.save

        measure_condition_component.measurement_unit_code = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME111)
      end
    end

    describe "Flag 'measurement unit' on duty expression is not permitted" do
      it "ME111: If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered." do
        duty_expression.measurement_unit_applicability_code = 2
        duty_expression.save

        measure_condition_component.measurement_unit_code = 'TNE'
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME111)
      end
    end

  end
end
