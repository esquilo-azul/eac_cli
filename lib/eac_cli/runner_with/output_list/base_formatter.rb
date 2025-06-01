# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  module RunnerWith
    module OutputList
      class BaseFormatter
        acts_as_abstract :to_output
        common_constructor :columns, :rows

        # @return [String]
        def build_column(column)
          column.to_s
        end

        # @return [Array<String>]
        def build_columns
          columns.map(&:to_s)
        end

        # @param row [Object]
        # @return [Object]
        def build_row(_row)
          raise_abstract_method __method__
        end

        # @return [Array<Hash<String, String>>]
        def build_rows
          rows.map { |row| build_row(row) }
        end

        # @param row [Object]
        # @param column [String]
        # @return [Object]
        def build_value(row, column)
          return row.send(column) if row.respond_to?(column)
          return row.with_indifferent_access.fetch(column) if row.is_a?(::Hash)

          raise ::ArgumentError, "Row \"#{row}\" do not respond to column \"#{column}\" neither " \
                                 "is a Hash (Row: #{row}, Column: #{column})"
        end
      end
    end
  end
end
