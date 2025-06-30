# frozen_string_literal: true

module EacCli
  module RunnerWith
    module Input
      STDIN_OPTION = '-'
      BLANK_OPTION = '+'
      DEFAULT_DEFAULT_INPUT_OPTION = BLANK_OPTION

      common_concern do
        enable_settings_provider
        include ::EacCli::Runner

        runner_definition do
          arg_opt '-i', '--input', 'Input from file.'
        end
      end

      def input_content
        case input_option
        when STDIN_OPTION then $stdin.read
        when BLANK_OPTION then ''
        else input_option.to_pathname.read
        end
      end

      def input_option
        parsed.input || setting_value(:default_input_option, default: DEFAULT_DEFAULT_INPUT_OPTION)
      end
    end
  end
end
