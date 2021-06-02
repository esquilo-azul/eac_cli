# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      common_concern do
        include ::EacCli::Runner

        runner_definition.alt do
          bool_opt '-h', '--help', 'Show help.', usage: true
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

      def help_text
        r = ::EacCli::Docopt::DocBuilder.new(self.class.runner_definition).to_s
        r += help_extra_text if respond_to?(:help_extra_text)
        r
      end

      def show_help?
        parsed.help? && !if_respond(:run_subcommand?, false)
      end
    end
  end
end
