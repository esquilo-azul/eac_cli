# frozen_string_literal: true

require 'eac_cli/definition'
require 'eac_cli/definition/error'
require 'eac_cli/runner/class_runner'

module EacCli
  module Runner
    module AfterClassMethods
      # @return [EacCli::Runner::ClassRunner]
      def class_runner(runner_context_args)
        ::EacCli::Runner::ClassRunner.new(self, runner_context_args)
      end

      def create(*runner_context_args)
        class_runner(runner_context_args).create
      end

      def run(*runner_context_args)
        class_runner(runner_context_args).run
      end

      def runner_definition(&block)
        @runner_definition ||= super_runner_definition
        begin
          @runner_definition.instance_eval(&block) if block
        rescue ::EacCli::Definition::Error => _e
          raise ::EacCli::Definition::Error, "Definition error for #{self}"
        end
        @runner_definition
      end

      def super_runner_definition
        superclass.try(:runner_definition).if_present(&:dup) || ::EacCli::Definition.new
      end
    end
  end
end
