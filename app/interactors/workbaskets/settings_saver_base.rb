module Workbaskets
  class SettingsSaverBase

    attr_accessor :current_step,
                  :save_mode,
                  :settings,
                  :workbasket,
                  :settings_params,
                  :step_pointer,
                  :attrs_parser,
                  :errors,
                  :candidates_with_errors

    def initialize(workbasket, current_step, save_mode, settings_ops={})
      @workbasket = workbasket
      @save_mode = save_mode
      @current_step = current_step
      @settings = workbasket.create_measures_settings
      @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

      setup_system_pointers!
      clear_cached_sequence_number!
    end

    def valid?
      check_required_params!

      if candidates.present?
        validate!
        candidates_with_errors.blank?
      end

      @errors.blank?
    end

    def save!
      if step_pointer.main_step?
        workbasket.title = workbasket_name
        workbasket.operation_date = operation_date.try(:to_date)
        workbasket.save
      end

      settings.set_settings_for!(
        current_step,
        step_pointer.step_settings(settings_params)
      )
    end

    def persist!
      @persist = true
      @measure_sids = []
      @quota_period_sids = [] if workbasket_type == "CreateQuota"

      validate!

      settings.measure_sids_jsonb = @measure_sids.to_json
      if workbasket_type == "CreateQuota"
        settings.quota_period_sids_jsonb = @quota_period_sids.to_json
      end

      if settings.save
        settings.set_searchable_data_for_created_measures!
      end
    end

    def success_ops
      ops = {}
      ops[:next_step] = step_pointer.next_step if step_pointer.has_next_step?

      ops
    end

    attrs_parser_methods.map do |option|
      define_method(option) do
        attrs_parser.public_send(option)
      end
    end

    private

      def validate!
        validate_candidates!
        get_unique_errors_from_candidates!
      end

      def validate_candidates!
        candidates.map do |code|
          candidate_errors = candidate_validation_errors(code, validation_mode)

          if candidate_errors.present?
            @candidates_with_errors[code.to_s] = candidate_errors
          end
        end
      end

      def validation_mode
        commodity_codes.present? ? :commodity_codes : :additional_codes
      end

      def current_admin
        workbasket.user
      end

      def get_unique_errors_from_candidates!
        summarizer = ::Workbaskets::Shared::CandidatesValidationsSummarizer.new(
          current_step, candidates_with_errors
        )
        summarizer.summarize!

        summarizer.errors.map do |k, v|
          @errors[k] = v
        end
      end

      def errors_translator(key)
        I18n.t(
          workbasket_type.titleize
                         .gsub(' ', '_')
                         .downcase
        )[:errors][key]
      end

      def setup_system_pointers!
        @step_pointer = "#{workbasket_type_prefix}::StepPointer".constantize.new(current_step)
        @attrs_parser = "#{workbasket_type_prefix}::AttributesParser".constantize.new(
          settings,
          current_step,
          settings_params
        )
        @errors = {}
        @candidates_with_errors = {}
      end

      def clear_cached_sequence_number!
        Rails.cache.delete("#{workbasket.id}_sequence_number")
      end

      begin :measures_related_methods
        def candidate_validation_errors(code, mode)
          errors_collection = {}

          measure = generate_new_measure!(code, mode)

          m_errors = measure_errors(measure)
          errors_collection[:measure] = m_errors if m_errors.present?

          associations_list.map do |name|
            if public_send(name).present?
              association_errors = send("#{name}_errors", measure)
              errors_collection[name] = association_errors if association_errors.present?
            end
          end

          errors_collection
        end

        associations_list.map do |name|
          define_method("#{name}_errors") do |measure|
            klass_name = name.split("_").map(&:capitalize).join('')

            "::Workbaskets::Shared::#{klass_name}".constantize.errors_in_collection(
              measure, system_ops, public_send(name)
            )
          end
        end

        def generate_new_measure!(code, mode)
          measure = Measure.new(
            attrs_parser.measure_params(code, mode)
          )
          measure.measure_sid = Measure.max(:measure_sid).to_i + 1

          if @persist.present?
            measure = assign_system_ops!(measure)
            measure.save
            @measure_sids << measure.measure_sid

            Measure.where(measure_sid: measure.measure_sid)
                   .first
          else
            measure
          end
        end

        def measure_errors(measure)
          ::Measures::ConformanceErrorsParser.new(
            measure, MeasureValidator, {}
          ).errors
        end

        def system_ops
          {
            workbasket_id: workbasket.id,
            operation_date: operation_date,
            current_admin_id: current_admin.id
          }
        end

        def assign_system_ops!(measure)
          system_ops_assigner = ::Workbaskets::Shared::SystemOpsAssigner.new(
            measure, system_ops
          )
          system_ops_assigner.assign!

          system_ops_assigner.record
        end

        def workbasket_type_prefix
          "::Workbaskets::#{workbasket_type}"
        end
      end
  end
end
