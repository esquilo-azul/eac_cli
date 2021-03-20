# frozen_string_literal: true

module EacCli
  module Runner
    module InstanceMethods
      PARSER_ERROR_EXIT_CODE = 1

      def run_run
        parsed
        run_callbacks(:run) { run }
      rescue ::EacCli::Parser::Error => e
        run_parser_error(e)
      rescue ::EacCli::Runner::Exit # rubocop:disable Lint/SuppressedException
        # Do nothing
      end

      def run_parser_error(error)
        $stderr.write("#{error}\n")
        ::Kernel.exit(PARSER_ERROR_EXIT_CODE)
      end

      def runner_context
        return @runner_context if @runner_context

        raise 'Context was required, but was not set yet'
      end

      def runner_context=(new_runner_context)
        @runner_context = new_runner_context
        @parsed = nil
      end

      def parsed
        @parsed ||= ::EacCli::Parser.new(self.class.runner_definition, runner_context.argv).parsed
      end
    end
  end
end
