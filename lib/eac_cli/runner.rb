# frozen_string_literal: true

require 'eac_cli/definition'
require 'eac_cli/docopt/runner_extension'
require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    extend ::ActiveSupport::Concern

    included do
      extend ClassMethods
      include InstanceMethods
      ::EacCli::Docopt::RunnerExtension.check(self)
    end

    module ClassMethods
      def runner_definition(&block)
        @runner_definition ||= ::EacCli::Definition.new
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end
    end

    module InstanceMethods
    end
  end
end
