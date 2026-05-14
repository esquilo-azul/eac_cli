# frozen_string_literal: true

module EacCli
  module Runner
    module ContextResponders
      class Runner < ::EacCli::Runner::ContextResponders::Base
        def callable?
          runner.respond_to?(method_name)
        end

        def call(*, &)
          runner.send(method_name, *, &)
        end
      end
    end
  end
end
