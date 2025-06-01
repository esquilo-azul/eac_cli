# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_cli/runner/context_responders/base'

module EacCli
  module Runner
    module ContextResponders
      class Runner < ::EacCli::Runner::ContextResponders::Base
        def callable?
          runner.respond_to?(method_name)
        end

        def call(*args, &block)
          runner.send(method_name, *args, &block)
        end
      end
    end
  end
end
