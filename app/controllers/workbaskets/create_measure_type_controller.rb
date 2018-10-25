module Workbaskets
  class CreateMeasureTypeController < Workbaskets::BaseController
    expose(:sub_klass) { "CreateMeasureType" }
    expose(:settings_type) { :create_measure_type }

    expose(:initial_step_url) do
      edit_create_measure_type_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:read_only_section_url) do
      create_measure_type_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_create_measure_type_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::CreateMeasureTypeForm.new
    end

    expose(:create_measure_type) do
      workbasket_settings.collection.first
    end

    def update
      saver.save!

      if saver.valid?
        workbasket_settings.track_step_validations_status!(current_step, true)

        if submit_for_cross_check_mode?
          saver.persist!
          submit_for_cross_check.run!

          render json: { redirect_url: submitted_url },
                 status: :ok
        else
          render json: saver.success_ops,
                       status: :ok
        end
      else
        workbasket_settings.track_step_validations_status!(current_step, false)

        render json: {
          step: current_step,
          errors_summary: saver.errors_summary,
          errors: saver.errors,
          conformance_errors: saver.conformance_errors
        }, status: :unprocessable_entity
      end
    end

    private

      def handle_validate_request!(validator)
        if validator.valid?
          render json: {},
                 status: :ok
        else
          render json: {
            step: :main,
            errors: validator.errors
          }, status: :unprocessable_entity
        end
      end

      def check_if_action_is_permitted!
        true
      end

      def submit_for_cross_check_mode?
        params[:mode] == "submit_for_cross_check"
      end
  end
end
