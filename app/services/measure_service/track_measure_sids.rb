module MeasureService
  class TrackMeasureSids

    CACHE_KEY_SEPARATOR = "_FM_ALL_IDS_"

    attr_accessor :search_code

    def initialize(search_code)
      @search_code = search_code
    end

    def valid?
      search.setup_sql_query
      search.any_filters_applied?
    end

    def run
      Rails.cache.write(
        cache_key,
        measure_sids
      )
    end

    private

      def cache_key
        search_code.gsub("_SM_", CACHE_KEY_SEPARATOR)
      end

      def measure_sids
        search.measure_sids
      end

      def search
        ::Measures::Search.new(
          search_ops
        )
      end

      def search_ops
        Rails.cache.read(search_code)
      end
  end
end
