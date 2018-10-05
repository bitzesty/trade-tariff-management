module Quotas
  module SearchFilters
    module FindQuotasCollection

      include ::Shared::SearchFilters::FindCollection

      def by_start_date_and_quota_definition_sid_reverse
        order(
            Sequel.desc(:quota_definitions__validity_start_date),
            Sequel.desc(:quota_definitions__quota_definition_sid)
        )
      end

      def operator_search_by_order_number(operator, order_number=nil)
        operator_search_where_clause("OrderNumber", operator, order_number)
      end

      def operator_search_by_description(operator, description=nil)
        operator_search_where_clause("Description", operator, description)
      end

      def operator_search_by_type(operator, type=nil)
        operator_search_where_clause("Type", operator, type)
      end

      def operator_search_by_regulation(operator, regulation=nil)
        operator_search_where_clause("Regulation", operator, regulation)
      end

      private

      def operator_search_where_clause(klass_name, operator, value=nil)
        q_rules = "::Quotas::SearchFilters::#{klass_name}".constantize.new(
            operator, value
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end

    end
  end
end
