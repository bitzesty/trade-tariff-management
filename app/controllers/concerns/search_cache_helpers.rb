module SearchCacheHelpers
  extend ActiveSupport::Concern

  included do
    expose(:search_code) do
      separator = controller_name.to_s == "measures" ? "_SM_" : "_BE_"
      code = "#{current_user.id}#{separator}#{Time.now.to_i}"

      Rails.cache.write(code, search_ops)

      code
    end

    expose(:cached_search_ops) do
      Rails.cache.read(params[:search_code]).merge(
        page: current_page
      )
    end

    expose(:full_search_params) do
      search_mode? ? cached_search_ops : nil
    end

    expose(:json_response) do
      {
        measures: json_collection,
        total_pages: search_results.total_pages,
        current_page: search_results.current_page,
        has_more: !search_results.last_page?
      }
    end

    expose(:pagination_metadata) do
      if search_mode?
         {
           page: search_results.current_page,
           total_count: search_results.total_count,
           per_page: search_results.limit_value
         }
      else
        {}
      end
    end

    expose(:current_page) do
      params[:page] || 1
    end
  end

  private

    def search_mode?
      params[:search_code].present? &&
      Rails.cache.exist?(params[:search_code])
    end
end
