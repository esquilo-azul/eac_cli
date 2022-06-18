# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/speaker'

module EacCli
  module Runner
    class ClassRunner
      PARSER_ERROR_EXIT_CODE = 1

      common_constructor :klass, :context_args

      def create
        r = klass.new
        r.runner_context = ::EacCli::Runner::Context.new(r, *context_args)
        r
      end

      def run
        on_asserted_speaker do
          r = create
          begin
            r.run_run
          rescue ::EacCli::Parser::Error => e
            run_parser_error(r, e)
          end
          r
        end
      end

      def run_parser_error(runner_instance, error)
        $stderr.write("#{runner_instance.program_name}: #{error}\n")
        ::Kernel.exit(PARSER_ERROR_EXIT_CODE)
      end

      private

      def on_asserted_speaker
        if ::EacRubyUtils::Speaker.context.optional_current
          yield
        else
          ::EacRubyUtils::Speaker.context.on(::EacCli::Speaker.new) do
            yield
          end
        end
      end
    end
  end
end
