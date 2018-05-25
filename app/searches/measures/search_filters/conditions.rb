#
# Form parameters:
#
# {
#    operator: 'include',
#    value: [
#       'A',
#       'B'
#    ] (eg: array of selected measure condition codes')
# }
#
# Operator possible options:
#
# - are
# - include
# - are_not_specified
# - are_not_unspecified
#
# Exxample:
#
# ::Measures::SearchFilters::Conditions.new(
#   "include", [ 'A', 'B' ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class Conditions

      attr_accessor :operator,
                    :conditions_list

      def initialize(operator, conditions_list)
        @operator = operator
        @conditions_list = conditions_list.uniq!
      end

      def sql_rules
        if %w(are include).include?(operator)

          sql = "#{initial_filter_sql} AND (#{condition_collection_sql_rules})"
          sql += " AND #{count_comparison_sql_rule}" if operator == "are"

          [sql, *condition_collection_compare_values].flatten
        else
          case operator
          when "are_not_specified"

            are_not_specified_sql_rule
          when "are_not_unspecified"

            are_not_unspecified_sql_rule
          end
        end
      end

      private

        def initial_filter_sql
          <<-eos
            searchable_data #>> '{"measure_conditions"}' IS NOT NULL
          eos
        end

        def condition_collection_sql_rules
          conditions_list.map do |code|
            <<-eos
              (searchable_data #>> '{"measure_conditions"}')::text ilike ?
            eos
          end.join(" AND ")
        end

        def condition_collection_compare_values
          conditions_list.map do |code|
            "%_#{code}_%"
          end
        end

        def count_comparison_sql_rule
          <<-eos
            searchable_data #>> '{"measure_conditions_count"}' = '#{conditions_list.count}'
          eos
        end

        def are_not_specified_sql_rule
          <<-eos
            searchable_data #>> '{"measure_conditions"}' IS NULL
          eos
        end

        def are_not_unspecified_sql_rule
          <<-eos
            searchable_data #>> '{"measure_conditions"}' IS NOT NULL
          eos
        end
    end
  end
end
