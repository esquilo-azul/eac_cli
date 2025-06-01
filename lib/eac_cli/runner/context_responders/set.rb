# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_cli/runner/context_responders/base'

module EacCli
  module Runner
    module ContextResponders
      class Set < ::EacCli::Runner::ContextResponders::Base
        attr_reader :responders_names

        def initialize(context, method_name, responders_names)
          super(context, method_name)
          @responders_names = responders_names
        end

        def callable?
          responders_instances.any?(&:callable?)
        end

        def call(...)
          caller = responder_to_call
          return caller.call(...) if caller

          raise ::NameError, "No method \"#{method_name}\" found in #{runner} or in its ancestors"
        end

        private

        def responder_class(class_name)
          ::EacCli::Runner::ContextResponders.const_get(class_name.to_s.camelize)
        end

        def responders_instances
          responders_names.lazy.map { |name| responder_class(name).new(context, method_name) }
        end

        def responder_to_call
          responders_instances.lazy.select(&:callable?).first
        end
      end
    end
  end
end
