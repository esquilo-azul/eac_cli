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
      def create(*context_args)
        r = new
        r.context = ::EacCli::Runner::Context.new(*context_args)
        r
      end

      def runner_definition(&block)
        @runner_definition ||= ::EacCli::Definition.new
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end
    end

    module InstanceMethods
      def context
        return @context if @context

        raise 'Context was required, but was not set yet'
      end

      def context=(new_context)
        @context = new_context
        @parsed = nil
      end

      def parsed
        @parsed ||= ::EacCli::Parser.new(self.class.runner_definition).parse(context.argv)
      end
    end
  end
end
