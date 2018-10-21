module WorkbasketValueObjects
  module CreateMeasureType
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase

      def has_next_step?
        false
      end

      def form_steps
        %w(
          main
        )
      end

      def main_step_settings
        %w(
          measure_type_series_id,
          measure_type_id,
          description
          operation_date
          validity_start_date
          validity_end_date
        )
      end
    end
  end
end
