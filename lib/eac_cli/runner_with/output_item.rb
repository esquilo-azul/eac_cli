# frozen_string_literal: true

module EacCli
  module RunnerWith
    module OutputItem
      require_sub __FILE__

      FORMATS = %w[csv yaml].freeze

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
        formats.fetch(parsed.format)
      end

      # @return [Hash<String, Class>]
      def formats
        FORMATS.to_h do |e|
          [e, ::EacCli::RunnerWith::OutputItem.const_get("#{e.camelize}Formatter")]
        end
      end

      # @return [Hash<String, Enumerable<String>]
      def help_extra_text
        help_list_section('Formats', formats.keys.sort)
      end
    end
  end
end
