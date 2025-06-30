# frozen_string_literal: true

require 'tty/table'

module EacCli
  module RunnerWith
    module OutputList
      class TtyFormatter < ::EacCli::RunnerWith::OutputList::BaseFormatter
        # @param row [Object]
        # @return [Array]
        def build_row(row)
          build_columns.map { |c| build_value(row, c) }
        end

        # @return [String]
        def to_output
          "#{tty_table_output}\n"
        end

        # @return [TTY::Table]
        def tty_table
          ::TTY::Table.new(build_columns, build_rows)
        end

        # @return [String]
        def tty_table_output
          tty_table.render(:unicode, multiline: true) do |renderer|
            renderer.border.separator = ->(row) { ((row + 1) % columns.count).zero? }
          end
        end
      end
    end
  end
end
