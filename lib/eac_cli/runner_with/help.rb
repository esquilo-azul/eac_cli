# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      require_sub __FILE__, require_mode: :kernel
      common_concern do
        include ::EacCli::Runner

        runner_definition.alt do
          bool_opt '-h', '--help', 'Show help.', usage: true, required: true
          pos_arg :any_arg_with_help, repeat: true, optional: true, visible: false
        end

        set_callback :run, :before do
          help_run
        end
      end

      def help_run
        return unless show_help?

        puts help_text
        raise ::EacCli::Runner::Exit
      end

      # @return [String]
      def help_text
        ::EacCli::RunnerWith::Help::Builder.new(self).to_s
      end

      def show_help?
        parsed.help? && !if_respond(:run_subcommand?, false)
      end
    end
  end
end
