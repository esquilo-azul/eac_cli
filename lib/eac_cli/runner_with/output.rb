# frozen_string_literal: true

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
        object_to_write.write(output_content)
      end

      def output_option
        parsed.output || default_output_option_value
      end

      def object_to_write
        case output_option
        when STDOUT_OPTION then $stdout
        when DEFAULT_FILE_OPTION then default_file_to_output_value
        else output_option.to_pathname
        end
      end

      def default_output_option_value
        setting_value(:default_output_option,
                      default: DEFAULT_DEFAULT_OUTPUT_OPTION)
      end

      # @return [Pathname]
      def default_file_to_output_value
        setting_value(:default_file_to_output, default: DEFAULT_DEFAULT_FILE_TO_OUTPUT).to_pathname
      end
    end
  end
end
