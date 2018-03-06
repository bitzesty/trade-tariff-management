module XmlGeneration
  class ExportsController < BaseController

    expose(:xml_export_files) do
      XmlExport::FileDecorator.decorate_collection(
        XmlExport::File.reverse_order(:issue_date)
                       .page(params[:page])
      )
    end

    def create
      record = ::XmlExport::File.new(
        relevant_date: date_for_export,
        issue_date: Time.zone.now,
        state: "P"
      )

      if record.save
        Rails.logger.info ""
        Rails.logger.info "-" * 10
        Rails.logger.info ""
        Rails.logger.info "[record ID] #{record.id}"
        Rails.logger.info ""
        Rails.logger.info "-" * 10
        Rails.logger.info ""

        ::XmlGeneration::ExportWorker.perform_async(record.id) unless Rails.env.test?

        redirect_to xml_generation_exports_path,
                    notice: "XML Export was successfully scheduled. Please wait!"
      else
        redirect_to xml_generation_exports_path,
                    notice: "Something wrong!"
      end
    end

    private

      def date_for_export
        params[:export_date].try(:to_date) || Date.today
      end
  end
end
