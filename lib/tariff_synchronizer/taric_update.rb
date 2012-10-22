require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class TaricUpdate < BaseUpdate
    self.update_priority = 2

    def self.download(date)
      status, file_name = get_taric_path(date)

      if file_name.present?
        taric_data_url = "#{TariffSynchronizer.host}/taric/#{file_name}"
        TariffSynchronizer.logger.info "Downloading Taric update for #{date} at: #{taric_data_url}"
        FileService.get_content(taric_data_url).tap{|status, contents|
          create_update_entry(date, file_name, status, "TaricUpdate")

          write_update_file(date, file_name, contents) if status == :success
        }
      else
        # we will be retrying a few more times today, so do not create
        # Missing record until we are sure
        unless date == Date.today
          TariffSynchronizer.logger.info "Taric update for #{date} is missing."
          create_update_entry(date, file_name, status, "TaricUpdate")
        end
      end
    end

    def apply
      TariffImporter.new(file_path, TaricImporter).import

      mark_as_applied
      logger.info "Successfully applied Taric update: #{file_path}"
    end

    def self.update_type
      :taric
    end

    def self.file_name_for(date)
      "#{date}_TGB#{date.strftime("%y")}#{date.yday}.xml"
    end

    def self.rebuild
      Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'taric', '*.xml')].each do |file_path|
        date, file_name = parse_file_path(file_path)

        create_update_entry(date, file_name, :success, "TaricUpdate")
      end
    end

    private

    def self.get_taric_path(date)
      date_query = Date.parse(date.to_s).strftime("%Y%m%d")
      taric_query_url = "#{TariffSynchronizer.host}/taric/TARIC3#{date_query}"
      TariffSynchronizer.logger.info "Checking for Taric file for #{date} at: #{taric_query_url}"
      FileService.get_content(taric_query_url).tap { |status, file_name|
        file_name.gsub!(/[^0-9a-zA-Z\.]/i, '') if file_name.present?
      }
    end
  end
end
