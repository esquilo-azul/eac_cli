# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/runner/context_responders/base'

module EacCli
  module Runner
    module ContextResponders
      class Parent < ::EacCli::Runner::ContextResponders::Base
        def callable?
          parent.if_present(false) do |v|
            next true if v.respond_to?(method_name)

            v.if_respond(:runner_context, false) { |w| w.parent_respond_to?(method_name) }
          end
        end

        def call(*args, &block)
          return parent.runner_context.call(method_name, *args, &block) if
            parent.respond_to?(:runner_context)

          raise "Parent #{parent} do not respond to .context or .runner_context (Runner: #{runner})"
        end
      end
    end
  end
end
