module XmlGeneration
  class ExportsController < BaseController

    expose(:xml_export_files) do
      XmlExport::FileDecorator.decorate_collection(
        XmlExport::File.reverse_order(:issue_date)
                       .page(params[:page])
      )
    end

    def create
      ::XmlGeneration::ExportWorker.perform_async(
        params[:export_date].try(:to_date) || Date.today
      )

      redirect_to xml_generation_exports_path,
                  notice: "XML Export was successfully scheduled. Please wait!"
    end
  end
end
