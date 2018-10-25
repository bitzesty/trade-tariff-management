module WorkbasketInteractions
  module CreateMeasureType
    class InitialValidator

      ALLOWED_OPS = %w(
        measure_type_series_id
        measure_type_id
        description
        validity_start_date
        validity_end_date
        operation_date
      )

      VALIDITY_PERIOD_ERRORS_KEYS = [
        :validity_start_date,
        :validity_end_date
      ]

      attr_accessor :settings,
                    :errors,
                    :errors_summary,
                    :start_date,
                    :end_date

      def initialize(settings)
        @errors = {}
        @settings = settings

        @start_date = parse_date(:validity_start_date)
        @end_date = parse_date(:validity_end_date)
        @operation_date = parse_date(:operation_date)
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        check_measure_type_series_id!
        check_measure_type_id!
        check_description!
        check_validity_period!
        check_operation_date!

        errors
      end

      def errors_translator(key)
        I18n.t(:create_measure_type)[key]
      end

      private

        def check_measure_type_series_id!
          if measure_type_series_id.blank?
            @errors[:measure_type_series_id] = errors_translator(:measure_type_series_id_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_measure_type_id!
          if measure_type_id.blank?
            @errors[:measure_type_id] = errors_translator(:measure_type_id_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          else
            if [3, 6].exclude? measure_type_id.size
              @errors[:measure_type_id] = errors_translator(:measure_type_id_size)
              @errors_summary = errors_translator(:summary_invalid_data)
            end

            if !numeric_string?(measure_type_id)
              @errors[:measure_type_id] = errors_translator(:measure_type_id_not_numeric)
              @errors_summary = errors_translator(:summary_invalid_data)
            end

            if MeasureType.where(measure_type_series_id: measure_type_series_id, measure_type_id: measure_type_id).present?
              @errors[:measure_type_id] = errors_translator(:measure_type_id_unique)
              @errors_summary = errors_translator(:summary_invalid_data)
            end
          end
        end

        def check_description!
          if description.blank? || ( description.present? && description.squish.split.size.zero?)
            @errors[:description] = errors_translator(:description_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_validity_period!
          if start_date.present?
            if end_date.present? && start_date > end_date
              @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
            end

          elsif @errors[:validity_start_date].blank?
            @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
          end

          if start_date.present? &&
             end_date.present? &&
             end_date < start_date

            @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
          end

          if VALIDITY_PERIOD_ERRORS_KEYS.any? do |error_key|
              errors.has_key?(error_key)
            end

            @errors_summary = errors_translator(:summary_invalid_data) if @errors_summary.blank?
          end
        end

        def check_operation_date!
          if operation_date.blank?
            @errors[:operation_date] = errors_translator(:operation_date_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def parse_date(option_name)
          date_in_string = public_send(option_name)

          begin
            Date.strptime(date_in_string, "%d/%m/%Y")
          rescue Exception => e
            if date_in_string.present?
              @errors[option_name] = errors_translator("#{option_name}_wrong_format".to_sym)
              @errors_summary = errors_translator(:summary_invalid_data)
            end

            nil
          end
        end

        def numeric_string?(str)
          Float(str) != nil rescue false
        end
    end
  end
end
