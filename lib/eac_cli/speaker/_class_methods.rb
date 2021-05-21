# frozen_string_literal: true

require 'eac_cli/speaker/node'

module EacCli
  module Speaker
    class << self
      def current_node
        nodes_stack.last
      end

      def on_node(&block)
        push
        yield(*(block.arity.zero? ? [] : [current_node]))
      ensure
        pop
      end

      def push
        nodes_stack << ::EacCli::Speaker::Node.new
        current_node
      end

      def pop
        return nodes_stack.pop if nodes_stack.count > 1

        raise "Cannot remove first node (nodes_stack.count: #{nodes_stack.count})"
      end

      private

      def nodes_stack
        @nodes_stack ||= [::EacCli::Speaker::Node.new]
      end
    end
  end
end
