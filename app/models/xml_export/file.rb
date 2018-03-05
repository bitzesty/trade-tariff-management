module XmlExport
  class File < Sequel::Model(:xml_export_files)

    include XmlDataUploader::Attachment.new(:xml)

    def after_create
      ::XmlGeneration::ExportWorker.perform_async(id) unless Rails.env.test?
    end

    class << self
      def max_per_page
        15
      end
    end
  end
end
