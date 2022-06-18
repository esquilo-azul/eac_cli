# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/speaker'

module EacCli
  module Runner
    class ClassRunner
      common_constructor :klass, :context_args

      def create
        r = klass.new
        r.runner_context = ::EacCli::Runner::Context.new(r, *context_args)
        r
      end

      def run
        on_asserted_speaker do
          r = create
          r.run_run
          r
        end
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
