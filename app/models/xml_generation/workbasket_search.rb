module XmlGeneration
  class WorkbasketSearch

    attr_accessor :start_date,
                  :end_date

    def initialize(date_filters)
      @start_date = date_filters[:start_date].strftime("%Y-%m-%d %H:%M:%S")
      @end_date = date_filters[:end_date].strftime("%Y-%m-%d %H:%M:%S") if date_filters[:end_date].present?
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(data)
    end

    private

      def data
        ::Workbaskets::Workbasket.xml_export_collection(
          start_date, end_date
        ).map do |workbasket|
          workbasket.settings
              .collection
        end.flatten
      end
  end
end
