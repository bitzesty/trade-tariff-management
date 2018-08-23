module XmlGeneration
  class Search

    attr_accessor :start_date,
                  :end_date

    def initialize(date_filters)
      @start_date = date_filters[:start_date].strftime("%Y-%m-%d")
      @end_date = date_filters[:end_date].strftime("%Y-%m-%d") if date_filters[:end_date].present?
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(data)
    end

    private

      def data
        res = ::Workbaskets::Workbasket.xml_export_collection(
          start_date, end_date
        )

        Rails.logger.info ""
        Rails.logger.info " res: #{res.all.map(&:inspect)}"
        Rails.logger.info ""

        res
      end
  end
end
