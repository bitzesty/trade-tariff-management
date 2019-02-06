class WorkbasketsSearch
  ALLOWED_FILTERS = %w(
    q
  ).freeze

  FIELDS_ALLOWED_FOR_ORDER = %w(
    id
    title
    type
    status
    last_status_change_at
    operation_date
  ).freeze

  attr_accessor :current_user,
                :search_term,
                :search_options,
                :q,
                :sort_by_field,
                :relation,
                :page

  def initialize(current_user, search_options = {})
    @current_user = current_user
    @search_options = search_options
    @search_term = search_options['q']
    @page = search_options[:page] || 1
    @sort_by_field = search_options[:sort_by]
  end

  def results
    order_workbaskets
    filter_workbaskets
    paginate_workbaskets
  end

private

  def order_workbaskets
    @relation = if FIELDS_ALLOWED_FOR_ORDER.include?(sort_by_field)
      Workbaskets::Workbasket.custom_field_order(sort_by_field, search_options[:sort_dir])
    else
      Workbaskets::Workbasket.default_order
    end

    @relation = relation.default_filter.relevant_for_manager(current_user)
  end

  def filter_workbaskets
    if search_term
      @relation = relation.q_search(search_term)
    end
  end

  def paginate_workbaskets
    relation.page(page)
  end
end
