# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/runner/context_responders/base'

module EacCli
  module Runner
    module ContextResponders
      class RunnerMissingMethod < ::EacCli::Runner::ContextResponders::Base
        def callable?
          responder_runner.present?
        end

        def call(*args, &block)
          responder_runner.send(method_name, *args, &block)
        end

        private

        def responder_runner
          parent.if_present(nil) do |v|
            next v if v.respond_to?(method_name) && v.for_context?(method_name)

            v.if_respond(:runner_context, nil) do |w|
              w.runner_missing_method_responder(method_name).send(__method__)
            end
          end
        end
      end
    end
  end
end
