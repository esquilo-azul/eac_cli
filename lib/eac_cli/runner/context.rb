# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    class Context
      attr_reader :argv, :parent, :program_name, :runner

      def initialize(runner, *context_args)
        options = context_args.extract_options!
        @argv = (context_args[0] || options.delete(:argv) || ARGV).dup.freeze
        @parent = context_args[1] || options.delete(:parent)
        @program_name = options.delete(:program_name)
        @runner = runner
      end

      # Call a method in the runner or in one of it ancestors.
      def call(method_name, *args)
        return runner.send(method_name, *args) if runner.respond_to?(method_name)
        return parent_call(method_name, *args) if parent_respond_to?(method_name)

        raise ::NameError, "No method \"#{method_name}\" found in #{runner} or in its ancestors"
      end

      # @param method_name [Symbol]
      # @return [Boolean]
      def parent_respond_to?(method_name)
        parent.if_present(false) do |v|
          next true if v.respond_to?(method_name)

          v.if_respond(:runner_context, false) { |w| w.parent_respond_to?(method_name) }
        end
      end

      def parent_call(method_name, *args)
        return parent.runner_context.call(method_name, *args) if parent.respond_to?(:runner_context)

        raise "Parent #{parent} do not respond to .context or .runner_context (Runner: #{runner})"
      end
    end
  end
end
