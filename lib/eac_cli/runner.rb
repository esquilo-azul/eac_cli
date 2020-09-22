# frozen_string_literal: true

require 'eac_cli/definition'
require 'eac_cli/docopt/runner_extension'
require 'eac_cli/parser'
require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    require_sub __FILE__
    extend ::ActiveSupport::Concern

    included do
      extend ClassMethods
      include InstanceMethods
      ::EacCli::Docopt::RunnerExtension.check(self)
    end

    module ClassMethods
      def create(*runner_context_args)
        r = new
        r.runner_context = ::EacCli::Runner::Context.new(*runner_context_args)
        r
      end

      def run(*runner_context_args)
        r = create(*runner_context_args)
        r.parsed
        r.run
        r
      end

      def runner_definition(&block)
        @runner_definition ||= ::EacCli::Definition.new
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end
    end

    module InstanceMethods
      def runner_context
        return @runner_context if @runner_context

        raise 'Context was required, but was not set yet'
      end

      def runner_context=(new_runner_context)
        @runner_context = new_runner_context
        @parsed = nil
      end

      def parsed
        @parsed ||= ::EacCli::Parser.new(self.class.runner_definition).parse(runner_context.argv)
      end
    end
  end
end
