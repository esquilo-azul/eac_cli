# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/speaker'

module EacCli
  module Runner
    module AfterClassMethods
      def create(*runner_context_args)
        r = new
        r.runner_context = ::EacCli::Runner::Context.new(r, *runner_context_args)
        r
      end

      def run(*runner_context_args)
        on_asserted_speaker do
          r = create(*runner_context_args)
          r.run_run
          r
        end
      end

      def runner_definition(&block)
        @runner_definition ||= super_runner_definition
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end

      def super_runner_definition
        superclass.try(:runner_definition).if_present(&:dup) || ::EacCli::Definition.new
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
