module Quotas
  class StopSaver

    attr_accessor :current_admin,
                  :workbasket,
                  :workbasket_settings

    def initialize(current_admin, workbasket, settings_ops={})
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings
    end

    def valid?
      workbasket_settings.main_step_settings['start_date'].present?
    end

    def persist!
      order_number = QuotaOrderNumber.where(quota_order_number_id: workbasket_settings.quota_definition.quota_order_number_id).first
      if order_number.validity_start_date <= operation_date
        if order_number.validity_end_date > operation_date
          order_number.validity_end_date = operation_date
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              order_number, system_ops.merge(operation: "U")
          ).assign!
          order_number.save
        end
      else
        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            order_number, system_ops.merge(operation: "D")
        ).assign!(false)
        order_number.destroy
      end

      QuotaDefinition.where(quota_order_number_id: workbasket_settings.quota_definition.quota_order_number_id).each do |definition|
        if definition.validity_start_date <= operation_date
          if definition.validity_end_date > operation_date
            #end date current
            definition.measures.each do |measure|
              end_date_measure!(measure)
            end
            definition.validity_end_date = operation_date
            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                definition, system_ops.merge(operation: "U")
            ).assign!
            definition.save
          end
        else
          #delete all in future
          definition.measures.each do |measure|
            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                measure, system_ops.merge(operation: "D")
            ).assign!(false)
            measure.destroy
          end
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              definition, system_ops.merge(operation: "D")
          ).assign!(false)
          definition.destroy
        end
      end
      workbasket.move_status_to!(current_admin, :awaiting_cross_check)
    end

    def success_response
      {}
    end

    def error_response
      {}
    end

    private

    def operation_date
      workbasket_settings.main_step_settings['start_date'].try(:to_date)
    end

    def system_ops
      {
          operation_date: operation_date,
          current_admin_id: current_admin.id,
          workbasket_id: workbasket.id,
          status: "awaiting_cross_check"
      }
    end

    def end_date_measure!(measure)
      measure.validity_end_date = operation_date

      measure.justification_regulation_id =
          workbasket_settings.main_step_settings['regulation_id'] || measure.measure_generating_regulation_id
      measure.justification_regulation_role =
          workbasket_settings.main_step_settings['regulation_role'] || measure.measure_generating_regulation_role

      ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          measure, system_ops.merge(operation: "U")
      ).assign!

      measure.save
    end

  end
end