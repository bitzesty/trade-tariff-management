require 'rails_helper'
require 'requirement_duty_expression_formatter'

describe RequirementDutyExpressionFormatter do
  describe '.format' do
    context 'duty amount present' do
      it 'result includes duty amount' do
        expect(
          described_class.format(duty_amount: '55')
        ).to match /55/
      end
    end

    context 'monetary unit, measurement unit & measurement_unit_qualifier are present ' do
      subject {
        described_class.format(measurement_unit: 'Tonne',
                                                  formatted_measurement_unit_qualifier: 'L',
                                                  monetary_unit: 'EUR')
      }

      it 'properly formats output' do
        expect(subject).to match /EUR\/\(Tonne\/L\)/
      end
    end

    context 'monetary unit and measurement unit are present' do
      subject {
        described_class.format(monetary_unit: 'EUR',
                                                  measurement_unit: 'KG')
      }

      it 'properly formats result' do
        expect(subject).to match /EUR\/KG/
      end
    end

    context 'measurement unit is present' do
      subject {
        described_class.format(measurement_unit: 'KG')
      }

      it 'properly formats output' do
        expect(subject).to match /KG/
      end
    end
  end

  describe '.prettify' do
    context 'has less than 4 decimal places' do
      it 'returns number with insignificant zeros stripped up to 2 decimal points' do
        expect(described_class.prettify(1.2)).to eq '1.20'
      end
    end

    context 'has 4 or more decimal places' do
      it 'returns formatted number with 4 decimal places' do
        expect(described_class.prettify(1.23456)).to eq '1.2346'
      end
    end
  end
end
