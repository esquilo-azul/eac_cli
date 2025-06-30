# frozen_string_literal: true

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
