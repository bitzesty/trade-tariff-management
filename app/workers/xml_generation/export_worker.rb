module XmlGeneration
  class ExportWorker
    include Sidekiq::Worker

    sidekiq_options queue: :xml_generation, retry: false

    def perform(export_date)
      ::XmlGeneration::TaricExport.new(export_date).run
    end
  end
end
