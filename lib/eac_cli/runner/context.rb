# frozen_string_literal: true

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
      def call(method_name, *args, &block)
        context_call_responder(method_name).call(*args, &block)
      end

      # @return [EacCli::Runner::ContextResponders]
      def context_call_responder(method_name)
        ::EacCli::Runner::ContextResponders::Set.new(self, method_name, %i[runner parent])
      end

      # @param method_name [Symbol]
      # @return [EacCli::Runner::ContextResponders::Parent]
      def runner_missing_method_responder(method_name)
        ::EacCli::Runner::ContextResponders::RunnerMissingMethod
          .new(self, method_name)
      end

      # @param method_name [Symbol]
      # @return [Boolean]
      def parent_respond_to?(method_name)
        parent.if_present(false) do |v|
          next true if v.respond_to?(method_name)

          v.if_respond(:runner_context, false) { |w| w.parent_respond_to?(method_name) }
        end
      end

      def parent_call(method_name, *args, &block)
        return parent.runner_context.call(method_name, *args, &block) if
          parent.respond_to?(:runner_context)

        raise "Parent #{parent} do not respond to .context or .runner_context (Runner: #{runner})"
      end

      # @param method_name [Symbol]
      # @return [EacCli::Runner::ContextResponders::Parent]
      def parent_responder(method_name)
        ::EacCli::Runner::ContextResponders::Parent.new(self, method_name)
      end
    end
  end
end
