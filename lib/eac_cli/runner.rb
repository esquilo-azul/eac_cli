# frozen_string_literal: true

require 'eac_cli/definition'
require 'eac_cli/docopt/runner_extension'
require 'eac_cli/parser'
require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    require_sub __FILE__
    extend ::ActiveSupport::Concern

    class << self
      def alias_runner_class_methods(klass, from_suffix, to_suffix)
        %i[create run].each do |method|
          alias_class_method(klass, build_method_name(method, from_suffix),
                             build_method_name(method, to_suffix))
        end
      end

      private

      def alias_class_method(klass, from, to)
        sklass = klass.singleton_class
        return unless sklass.method_defined?(from)

        sklass.alias_method to, from
      end

      def build_method_name(name, suffix)
        ss = suffix.if_present('') { |s| "#{s}_" }
        "#{ss}#{name}"
      end
    end

    the_module = self
    included do
      the_module.alias_runner_class_methods(self, '', 'original')

      extend AfterClassMethods
      include InstanceMethods
      ::EacCli::Docopt::RunnerExtension.check(self)
    end

    module AfterClassMethods
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
        @runner_definition ||= super_runner_definition
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end

      def super_runner_definition
        superclass.try(:runner_definition).if_present(&:dup) || ::EacCli::Definition.new
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
