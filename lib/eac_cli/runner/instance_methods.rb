# frozen_string_literal: true

module EacCli
  module Runner
    module InstanceMethods
      def run_run
        parsed
        run_callbacks(:run) { run }
      rescue ::EacCli::Runner::Exit # rubocop:disable Lint/SuppressedException
        # Do nothing
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

      def program_name
        runner_context.if_present(&:program_name) || $PROGRAM_NAME
      end

      def respond_to_missing?(method, include_all = false)
        runner_context.respond_to_call?(method) || super
      end

      def method_missing(method, *args, &block)
        return super unless runner_context.respond_to_call?(method)

        runner_context.call(method, *args, &block)
      end
    end
  end
end
