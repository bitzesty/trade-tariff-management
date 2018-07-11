module Measures
  class Search

    ALLOWED_FILTERS = %w(
      group_name
      status
      author
      date_of
      last_updated_by
      regulation
      type
      valid_from
      valid_to
      commodity_code
      additional_code
      origin
      origin_exclusions
      duties
      conditions
      footnotes
    )

    NO_FILTERS_SQL_QUERY = "SELECT * FROM \"measures\" ORDER BY \"validity_start_date\" DESC, \"measure_sid\" DESC"

    attr_accessor *([:relation, :search_ops, :page] + ALLOWED_FILTERS)

    def initialize(search_ops)
      @search_ops = search_ops
      @page = search_ops[:page] || 1
    end

    def results(paginated_query=true)
      setup_sql_query(paginated_query)

      if no_any_filters_applied?
        #
        # If there are no any filters applied - then ignore that search.
        #

        []
      else
        if Rails.env.development?
          p ""
          p "-" * 100
          p ""
          p " search_ops: #{search_ops.inspect}"
          p ""
          p " SQL: #{relation.sql}"
          p ""
          p "-" * 100
          p ""
        end

        relation
      end
    end

    def setup_sql_query(paginated_query)
      @relation = Measure.by_start_date_and_measure_sid_reverse
      @relation = relation.page(page) if paginated_query
      @relation = relation.operation_search_jsonb_default if jsonb_search_required?

      search_ops.select do |k, v|
        ALLOWED_FILTERS.include?(k.to_s) &&
        v.present? &&
        v[:enabled].present? &&
        collection_filter_is_missing_or_having_proper_values?(v)
      end.each do |k, v|
        instance_variable_set("@#{k}", search_ops[k])
        send("apply_#{k}_filter")
      end
    end

    def any_filters_applied?
      !no_any_filters_applied?
    end

    def no_any_filters_applied?
      relation.sql == NO_FILTERS_SQL_QUERY
    end

    def measure_sids
      results(false).pluck(:measure_sid)
    end

    private

      def collection_filter_is_missing_or_having_proper_values?(v)
        val = v[:value]
        return true if val.blank?

        !val.is_a?(Hash) ||
        (
          val.is_a?(Hash) && val.values.reject { |el| el.blank? }.present?
        )
      end

      def jsonb_search_required?
        group_name ||
        regulation ||
        origin_exclusions ||
        duties ||
        conditions ||
        footnotes
      end

      def apply_group_name_filter
        @relation = relation.operator_search_by_group_name(
          *query_ops(group_name)
        )
      end

      def apply_status_filter
        @relation = relation.operator_search_by_status(
          *query_ops(status)
        )
      end

      def apply_author_filter
        val = just_value(author)
        @relation = relation.operator_search_by_author(val) if val.present?
      end

      def apply_last_updated_by_filter
        val = just_value(last_updated_by)
        @relation = relation.operator_search_by_last_updated_by(val) if val.present?
      end

      def apply_date_of_filter
        @relation = relation.operator_search_by_date_of(
          query_ops(date_of)
        )
      end

      def apply_regulation_filter
        @relation = relation.operator_search_by_regulation(
          *query_ops(regulation)
        )
      end

      def apply_type_filter
        @relation = relation.operator_search_by_measure_type(
          *query_ops(type)
        )
      end

      def apply_valid_from_filter
        @relation = relation.operator_search_by_valid_from(
          *query_ops(valid_from)
        )
      end

      def apply_valid_to_filter
        @relation = relation.operator_search_by_valid_to(
          *query_ops(valid_to)
        )
      end

      def apply_commodity_code_filter
        @relation = relation.operator_search_by_commodity_code(
          *query_ops(commodity_code)
        )
      end

      def apply_additional_code_filter
        @relation = relation.operator_search_by_additional_code(
          *query_ops(additional_code)
        )
      end

      def apply_origin_filter
        @relation = relation.operator_search_by_origin(
          *query_ops(origin)
        )
      end

      def apply_origin_exclusions_filter
        @relation = relation.operator_search_by_origin_exclusions(
          *query_ops(origin_exclusions)
        )
      end

      def apply_duties_filter
        @relation = relation.operator_search_by_duties(
          *query_ops(duties)
        )
      end

      def apply_conditions_filter
        @relation = relation.operator_search_by_conditions(
          *query_ops(conditions)
        )
      end

      def apply_footnotes_filter
        @relation = relation.operator_search_by_footnotes(
          *query_ops(footnotes)
        )
      end

      def query_ops(ops)
        val = just_value(ops)

        if ops[:mode].present?
          ops
        else
          [
            ops[:operator],
            val.is_a?(Hash) ? val.values : val
          ]
        end
      end

      def just_value(ops)
        ops[:value]
      end
  end
end
