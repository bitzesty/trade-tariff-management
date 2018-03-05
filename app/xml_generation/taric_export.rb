module XmlGeneration
  class TaricExport

    FETCHABLE_DATA_MODELS = %w(
      measure
      measure_type
      measure_type_description
      measure_component
      transmission_comment
    )

    attr_accessor :export_date

    def initialize(export_date)
      @export_date = export_date.to_date
    end

    def run
      fetch_relevant_data
      generate_xml
      save_xml!
    end

    private

      def fetch_relevant_data
        @data = TimeMachine.at(export_date) do
          FETCHABLE_DATA_MODELS.map do |model_name|
            model_name.actual
          end
        end
      end

      def generate_xml
        ::XmlGeneration::XmlNodes::Transaction
        renderer.render(transactions, xml: xml)
      end

      def save_xml!

      end

      def xml_builder
        Builder::XmlMarkup.new
      end

      def renderer
        Tilt.new("#{base_partial_path}/main.builder")
      end

      def base_partial_path
        "#{Rails.root}/app/views/xml_generation/templates"
      end
  end
end
