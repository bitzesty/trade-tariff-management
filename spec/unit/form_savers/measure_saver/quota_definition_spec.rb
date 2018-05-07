require "rails_helper"

describe "Measure Saver: Saving of Quota definitions" do

  include_context "measure_saver_base_context"

  let(:order_number_ops) do
    {
      existing_quota: "false",
      quota_status: "open",
      quota_ordernumber: "090716",
      quota_criticality_threshold: "15",
      quota_description: "Test description"
    }
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    commodity

    measure_saver.valid?
    measure_saver.persist!
  end

  describe "Invalid params (without quota periods)" do
    let(:ops) do
      base_ops.merge(
        order_number_ops
      )
    end

    it "should not create new duty_expressions" do
      expect(measure.reload.new?).to be_falsey

      expect(QuotaOrderNumber.count).to be_eql(0)
      expect(QuotaDefinition.count).to be_eql(0)
    end
  end

  describe "Successful saving" do
    let(:start_period_date) { "08/05/2018" }

    describe "Annual" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            annual: {
              "amount1" => "10",
              "start_date" => start_period_date,
              "measurement_unit_code" => "EUR",
              "measurement_unit_qualifier_code" => "X"
            }
          }
        )
      end

      it "should create order number and annual quota defition" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(1)

        expect_order_number_to_be_valid

        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date + 1.year,
          ops[:quota_periods][:annual]
        )
      end
    end

    # describe "Bi-Annual" do
    #   let(:ops) do
    #     base_ops.merge(
    #       order_number_ops
    #     ).merge(
    #       quota_periods: {
    #         bi_annual: {
    #           "amount1"=>"10",
    #           "amount2"=>"20",
    #           "start_date"=>"08/05/2018",
    #           "measurement_unit_code"=>"EUR",
    #           "measurement_unit_qualifier_code"=>"X"
    #         }
    #       }
    #     )
    #   end

    #   it "should create order number and bi-annual quota defitions" do
    #     expect(measure.reload.new?).to be_falsey

    #     expect(QuotaOrderNumber.count).to be_eql(1)
    #     expect(QuotaDefinition.count).to be_eql(2)

    #     expect_order_number_to_be_valid
    #   end
    # end

    # describe "Quarterly" do
    #   let(:ops) do
    #     base_ops.merge(
    #       order_number_ops
    #     ).merge(
    #       quota_periods: {
    #         quarterly: {
    #           "amount1"=>"10",
    #           "amount2"=>"20",
    #           "amount3"=>"30",
    #           "amount4"=>"40",
    #           "start_date"=>"08/05/2018",
    #           "measurement_unit_code"=>"EUR",
    #           "measurement_unit_qualifier_code"=>"X"
    #         }
    #       }
    #     )
    #   end

    #   it "should create order number and 1 quota defition per each quarter of year" do
    #     expect(measure.reload.new?).to be_falsey

    #     expect(QuotaOrderNumber.count).to be_eql(1)
    #     expect(QuotaDefinition.count).to be_eql(4)

    #     expect_order_number_to_be_valid
    #   end
    # end

    # describe "Monthly" do
    #   let(:ops) do
    #     base_ops.merge(
    #       order_number_ops
    #     ).merge(
    #       quota_periods: {
    #         monthly: {
    #           "amount1"=>"10",
    #           "amount2"=>"20",
    #           "amount3"=>"30",
    #           "amount4"=>"40",
    #           "amount5"=>"50",
    #           "amount6"=>"60",
    #           "amount7"=>"70",
    #           "amount8"=>"80",
    #           "amount9"=>"90",
    #           "amount10"=>"100",
    #           "amount11"=>"110",
    #           "amount12"=>"120",
    #           "start_date"=>"08/05/2018",
    #           "measurement_unit_code"=>"EUR",
    #           "measurement_unit_qualifier_code"=>"X"
    #         }
    #       }
    #     )
    #   end

    #   it "should create order number and 1 quota defition per each month of year" do
    #     expect(measure.reload.new?).to be_falsey

    #     expect(QuotaOrderNumber.count).to be_eql(1)
    #     expect(QuotaDefinition.count).to be_eql(12)

    #     expect_order_number_to_be_valid
    #   end
    # end

    # describe "Custom" do
    #   let(:ops) do
    #     base_ops.merge(
    #       order_number_ops
    #     ).merge(
    #       quota_periods: {
    #         custom: {
    #           "0" => {
    #             "amount1"=>"10",
    #             "start_date"=>"08/05/2018",
    #             "end_date"=>"08/05/2019",
    #             "measurement_unit_code"=>"EUR",
    #             "measurement_unit_qualifier_code"=>"X"
    #           },
    #           "1" => {
    #             "amount1"=>"20",
    #             "start_date"=>"08/05/2019",
    #             "end_date"=>"08/05/2020",
    #             "measurement_unit_code"=>"EUR",
    #             "measurement_unit_qualifier_code"=>"X"
    #           }
    #         }
    #       }
    #     )
    #   end

    #   it "should create order number and annual quota defition" do
    #     expect(measure.reload.new?).to be_falsey

    #     expect(QuotaOrderNumber.count).to be_eql(1)
    #     expect(QuotaDefinition.count).to be_eql(2)

    #     expect_order_number_to_be_valid
    #   end
    # end
  end

  private

    def order_number
      measure.reload
             .order_number
    end

    def quota_definitions
      QuotaDefinition.where(
        quota_order_number_id: order_number.quota_order_number_id
      ).all
    end

    def expect_order_number_to_be_valid
      expect(order_number.quota_order_number_id).to be_eql(measure.ordernumber)

      expect(date_to_s(order_number.validity_start_date)).to be_eql(
        date_to_s(measure.validity_start_date)
      )
      expect(order_number.validity_end_date).to be_nil
      expect(date_to_s(order_number.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(order_number.added_at).not_to be_nil
      expect(order_number.added_by_id).to be_eql(user.id)
    end

    def expect_quota_definition_to_be_valid(record, amount, expected_end_date, ops)
      expect(record.quota_order_number_id).to be_eql(order_number.quota_order_number_id)
      expect(record.quota_order_number_sid).to be_eql(order_number.quota_order_number_sid)
      expect(record.initial_volume.to_i).to be_eql(amount)
      expect(date_to_s(record.validity_start_date)).to be_eql(ops["start_date"])

      expect(
        date_to_s(record.validity_end_date)
      ).to be_eql(
        date_to_s(expected_end_date)
      )

      %w(
        monetary_unit_code
        measurement_unit_code
        measurement_unit_qualifier_code
      ).map do |field_name|
        expect(record.public_send(field_name)).to be_eql(ops[field_name])
      end

      expect(date_to_s(record.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(record.added_at).not_to be_nil
      expect(record.added_by_id).to be_eql(user.id)
    end
end
