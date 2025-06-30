# frozen_string_literal: true

module EacCli
  module RunnerWith
    module OutputList
      require_sub __FILE__

      FORMATS = {
        'csv' => ::EacCli::RunnerWith::OutputList::CsvFormatter,
        'tty' => ::EacCli::RunnerWith::OutputList::TtyFormatter,
        'yaml' => ::EacCli::RunnerWith::OutputList::YamlFormatter
      }.freeze

      common_concern do
        acts_as_abstract :list_columns, :list_rows
        include ::EacCli::RunnerWith::Output

        runner_definition do
          arg_opt '-f', '--format', 'Format to output list.', default: 'yaml'
        end
      end

      # @return [String]
      def output_content
        formatter.to_output
      end

      # @return [EacCli::RunnerWith::OutputList::BaseFormatter]
      def formatter
        formatter_class.new(list_columns, list_rows)
      end

      # @return [Class]
      def formatter_class
        FORMATS.fetch(parsed.format)
      end
    end
  end
end
