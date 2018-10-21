module WorkbasketInteractions
  module CreateMeasureType
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        measure_type_serries_id
        measure_type_id
        description
        validity_start_date
        validity_end_date
        operation_date
      )

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,
                    :measure_type,
                    :measure_type_description,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.operation_date = operation_date
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
      end

      def success_ops
        {}
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      private

        def validate!
          check_initial_validation_rules!
          check_conformance_rules! if errors.blank?
        end

        def check_initial_validation_rules!
          @initial_validator = ::WorkbasketInteractions::CreateMeasureType::InitialValidator.new(
            settings_params
          )

          @errors = initial_validator.fetch_errors
          @errors_summary = initial_validator.errors_summary
        end

        def check_conformance_rules!
          Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
            add_measure_type!
            add_measure_type_description!

            parse_and_format_conformance_rules
          end
        end

        def parse_and_format_conformance_rules
          @conformance_errors = {}

          unless measure_type.conformant?
            @conformance_errors.merge!(get_conformance_errors(measure_type))
          end

          unless measure_type_description.conformant?
            @conformance_errors.merge!(get_conformance_errors(measure_type_description))
          end

          if conformance_errors.present?
            @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
          end
        end

        def add_measure_type!
          @measure_type = MeasureType.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          measure_type.measure_type_series_id = measure_type_series_id
          measure_type.measure_type_id = measure_type_id

          assign_system_ops!(measure_type)
          set_primary_key!(measure_type)

          measure_type.save if persist_mode?
        end

        def add_measure_type_description!
          @measure_type_description = MeasureTypeDescription.new(
            description: description
          )

          measure_type_description.measure_type_id = measure_type.measure_type_id

          assign_system_ops!(measure_type_description)
          set_primary_key!(measure_type_description)

          measure_type_description.save if persist_mode?
        end

        def persist_mode?
          @persist.present?
        end

        def setup_attrs_parser!
          @attrs_parser = ::WorkbasketValueObjects::CreateMeasureType::AttributesParser.new(
            settings_params
          )
        end

        def get_conformance_errors(record)
          res = {}

          record.conformance_errors.map do |k, v|
            message = if v.is_a?(Array)
                        v.flatten.join(' ')
                      else
                        v
                      end

            res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k.to_s}</strong>: #{message}".html_safe
          end

          res
        end
    end
  end
end
