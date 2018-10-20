module WorkbasketInteractions
  module EditFootnote
    class InitialValidator

      ALLOWED_OPS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        validity_start_date
        validity_end_date
        commodity_codes
        measure_sids
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
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        check_reason_for_changes!
        check_operation_date!
        check_description!
        check_description_validity_start_date!
        check_validity_period!
        check_commodity_codes!
        check_measures!

        errors
      end

      def errors_translator(key)
        I18n.t(:create_footnote)[key]
      end

      private

        def check_reason_for_changes!
          if reason_for_changes.blank?
            @errors[:reason_for_changes] = errors_translator(:reason_for_changes_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_operation_date!
          oper_date = parse_date(operation_date)

          if oper_date.present?
            if start_date.present? && oper_date < start_date
              @errors[:operation_date] = errors_translator(:operation_date_is_before_start_date)
            end
          else
            @errors[:operation_date] = errors_translator(:operation_date_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_description!
          if description.blank? || (
              description.present? &&
              description.squish.split.size.zero?
            )

            @errors[:description] = errors_translator(:description_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_description_validity_start_date!
          desc_date = parse_date(description_validity_start_date)

          if desc_date.present?
            if start_date.present?
              if end_date.present?
                if desc_date < start_date || desc_date > end_date
                  @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_outside_range)
                  @errors_summary = errors_translator(:summary_invalid_fields)
                end

              else
                if desc_date < start_date
                  @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_outside_range)
                  @errors_summary = errors_translator(:summary_invalid_fields)
                end
              end
            end

          else
            @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_blank)
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

            @errors_summary = errors_translator(:summary_invalid_validity_period) if @errors_summary.blank?
          end
        end

        def check_commodity_codes!
          if commodity_codes.present?
            list = parse_list_of_values(commodity_codes)

            if list.present?
              db_list = GoodsNomenclature.where(goods_nomenclature_item_id: list)
                                         .distinct(:goods_nomenclature_item_id)

              if db_list.count < list.count
                @errors[:commodity_codes] = errors_translator(:commodity_codes_not_recognized)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end
            end
          end
        end

        def check_measures!
          if measure_sids.present?
            list = parse_list_of_values(measure_sids)

            if list.present?
              db_list = Measure.where(measure_sid: list)
                               .distinct(:measure_sid)

              if db_list.count < list.count
                @errors[:measure_sids] = errors_translator(:measures_not_recognized)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end
            end
          end
        end

        def parse_date(option_name)
          date_in_string = public_send(option_name)

          begin
            Date.strptime(date_in_string, "%d/%m/%Y")
          rescue Exception => e
            if date_in_string.present?
              @errors[option_name] = errors_translator("#{option_name}_wrong_format".to_sym)
            end

            nil
          end
        end

        def parse_list_of_values(list_of_ids)
          # Split by linebreaks
          linebreaks_separated_list = list_of_ids.split(/\n+/)

          # Split by commas
          comma_separated_list = linebreaks_separated_list.map do |item|
            item.split(",")
          end.flatten

          # Split by whitespaces
          white_space_separated_list = comma_separated_list.map do |item|
            item.split(" ")
          end.flatten

          white_space_separated_list.map(&:squish)
                                    .flatten
                                    .reject { |i| i.blank? }.uniq
        end
    end
  end
end
