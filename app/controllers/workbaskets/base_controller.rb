module Workbaskets
  class BaseController < Measures::BulksBaseController

    around_action :configure_time_machine

    before_action :require_to_be_workbasket_owner!,
                  :require_step_declaration_in_params!,
                  :check_if_action_is_permitted!,
                  :status_check!, only: [ :edit, :update ]

    before_action :handle_submit_for_cross_check!, only: [:update]

    expose(:workbasket_settings) do
      workbasket.settings
    end

    expose(:current_step) { params[:step] }

    expose(:step_pointer) do
      namespace_constant("StepPointer").new(current_step)
    end

    expose(:previous_step) do
      step_pointer.previous_step
    end

    expose(:saver_mode) { params[:mode] }

    expose(:settings_params) do
      ops = params[:settings]
      ops.send("permitted=", true)
      ops = ops.to_h

      ops
    end

    expose(:form) do
      "Workbaskets::#{sub_klass}Form".constantize.new(
        Measure.new
      )
    end

    expose(:saver) do
      namespace_constant("SettingsSaver").new(
        workbasket,
        current_step,
        saver_mode,
        settings_params
      )
    end

    expose(:attributes_parser) do
      namespace_constant("AttributesParser").new(
        workbasket_settings,
        current_step
      )
    end

    expose(:submit_for_cross_check) do
      namespace_constant("SubmitForCrossCheck").new(
        workbasket
      )
    end

    def new
      self.workbasket = Workbaskets::Workbasket.buld_new_workbasket!(
        settings_type, current_user
      )

      redirect_to initial_step_url
    end

    private

      def require_step_declaration_in_params!
        if current_step.blank?
          redirect_to initial_step_url
          return false
        end
      end

      def status_check!
        unless workbasket.in_progress?
          redirect_to read_only_section_url
          return false
        end
      end

      def handle_submit_for_cross_check!
        if step_pointer.review_and_submit_step?
          submit_for_cross_check.run!

          render json: { redirect_url: read_only_section_url },
                 status: :ok

          return false
        end
      end

      def namespace_constant(target_klass)
        "::Workbaskets::#{sub_klass}::#{target_klass}".constantize
      end
  end
end
