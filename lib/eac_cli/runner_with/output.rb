# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils'

module EacCli
  module RunnerWith
    module Output
      STDOUT_OPTION = '-'
      DEFAULT_FILE_OPTION = '+'
      DEFAULT_DEFAULT_OUTPUT_OPTION = STDOUT_OPTION
      DEFAULT_DEFAULT_FILE_TO_OUTPUT = 'output'

      common_concern do
        enable_abstract_methods
        enable_settings_provider
        include ::EacCli::Runner

        abstract_methods :output_content

        runner_definition do
          arg_opt '-o', '--output', 'Output to file.'
        end
      end

      def run_output
        file = file_to_output
        if file
          file.to_pathname.write(output_content)
        else
          $stdout.write(output_content)
        end
      end

      def output_option
        parsed.output || default_output_option_value
      end

      def file_to_output
        case output_option
        when STDOUT_OPTION then nil
        when DEFAULT_FILE_OPTION then default_file_to_output_value
        else output_option
        end
      end

      def default_output_option_value
        setting_value(:default_output_option,
                      default: DEFAULT_DEFAULT_OUTPUT_OPTION)
      end

      def default_file_to_output_value
        setting_value(:default_file_to_output, default: DEFAULT_DEFAULT_FILE_TO_OUTPUT)
      end
    end
  end
end
