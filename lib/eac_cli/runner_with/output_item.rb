# frozen_string_literal: true

module EacCli
  module RunnerWith
    module OutputItem
      require_sub __FILE__

      FORMATS = {
        'csv' => ::EacCli::RunnerWith::OutputItem::CsvFormatter,
        'yaml' => ::EacCli::RunnerWith::OutputItem::YamlFormatter
      }.freeze

      common_concern do
        acts_as_abstract :item_hash
        include ::EacCli::RunnerWith::Output

        runner_definition do
          arg_opt '-f', '--format', 'Format to output item.', default: 'yaml'
        end
      end

      # @return [String]
      def output_content
        formatter.to_output
      end

      # @return [EacCli::RunnerWith::OutputList::BaseFormatter]
      def formatter
        formatter_class.new(item_hash)
      end

      # @return [Class]
      def formatter_class
        FORMATS.fetch(parsed.format)
      end
    end
  end
end
