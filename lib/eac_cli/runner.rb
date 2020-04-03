# frozen_string_literal: true

require 'eac_cli/runner/definition'
require 'eac_cli/runner/docopt_doc'
require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    extend ::ActiveSupport::Concern

    included do
      extend ClassMethods
      include InstanceMethods
    end

    module ClassMethods
      def runner_definition(&block)
        @runner_definition ||= ::EacCli::Runner::Definition.new
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end
    end

    module InstanceMethods
      def doc
        ::EacCli::Runner::DocoptDoc.new(self.class.runner_definition).to_s
      end
    end
  end
end
