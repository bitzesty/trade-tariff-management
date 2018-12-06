module XmlExport
  class File < Sequel::Model(:xml_export_files)

    class << self
      def include_uploader(type)
        include XmlDataUploader::Attachment.new(type, file_storage[type])
      end

      def file_storage
        disk = { cache: :disk_cache, store: :disk_store }
        s3 = { cache: :s3_cache, store: :s3_store }
        ftp = { cache: :s3_cache, store: :hmrc_ftp }

        if Rails.env.production?
          { xml: ftp, meta: ftp, base_64: s3, zip: s3, }
        else
          { xml: disk, meta: disk, base_64: disk, zip: disk }
        end
      end
    end

    include_uploader(:xml)
    include_uploader(:base_64)
    include_uploader(:zip)
    include_uploader(:meta)

    plugin :serialization

    serialize_attributes :yaml, :date_filters

    def save_with_envelope_id(envelope_id: envelope_id_sql)
      self.class.db.transaction do
        save
        self.class.where(id: id).update(envelope_id: Sequel.lit(envelope_id.to_s))
        reload
      end
    end

    private

    def envelope_id_sql
      # Format: YYxxxx (YY = current year, xxxx = number sequence this year)
      # Every year, first working day of January, the sequence is expected to
      # be reset, e.g. 190001, 200001, 210001

      <<~SQL
        (
          SELECT GREATEST(
            (
              SELECT MAX(envelope_id)
                     FROM xml_export_files
                     WHERE EXTRACT(year FROM issue_date) = date_part('year', CURRENT_DATE)
            ) + 1,
            #{initial_envelope_id_for_current_year}
          )
        )
      SQL
    end

    def initial_envelope_id_for_current_year
      next_id = envelope_id_offset_for_current_year + 1
      padded_id = next_id.to_s.rjust(4, "0")
      year_part = Date.current.strftime("%y")

      "#{year_part}#{padded_id}"
    end

    def envelope_id_offset_for_current_year
      ENV.fetch("XML_ENVELOPE_ID_OFFSET_YEAR_#{Date.current.year}", 0).to_i
    end

    class << self
      def max_per_page
        15
      end

      def default_per_page
        15
      end

      def max_pages
        999
      end
    end
  end
end
