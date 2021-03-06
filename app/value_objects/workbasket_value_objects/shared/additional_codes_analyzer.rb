module WorkbasketValueObjects
  module Shared
    class AdditionalCodesAnalyzer
      attr_accessor :start_date,
                    :additional_codes,
                    :collection,
                    :additional_codes_detected

      def initialize(ops = {})
        @collection = nil
        @start_date = get_start_date(ops)
        @additional_codes = ops[:additional_codes]

        setup_collection!
      end

      def additional_codes_formatted
        clean_array(additional_codes_detected).join(', ')
      end

    private

      def get_start_date(ops)
        ops[:start_date].to_date rescue Date.today
      end

      def setup_collection!
        if list_of_codes.present?
          @collection = fetch_additional_codes
        end

        clean_array(collection).sort do |a, b|
          a <=> b
        end
      end

      def list_of_codes
        if additional_codes.present?
          additional_codes.split(/[\s|,]+/)
              .map(&:strip)
              .reject(&:blank?)
              .uniq.sort
        end
      end

      def fetch_additional_codes
        TimeMachine.at(start_date) do
          @additional_codes_detected = list_of_codes.map do |code|
            AllAdditionalCode.by_code(code)
          end.reject(&:blank?).map(&:code)
        end
        @additional_codes_detected
      end

      def clean_array(list)
        (list || []).flatten
                    .reject(&:blank?)
                    .uniq.sort
      end
    end
  end
end
