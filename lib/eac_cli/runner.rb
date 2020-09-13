# frozen_string_literal: true

require 'eac_cli/definition'
require 'eac_cli/docopt/doc_builder'
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
        @runner_definition ||= ::EacCli::Definition.new
        @runner_definition.instance_eval(&block) if block
        @runner_definition
      end
    end

    module InstanceMethods
      def doc
        ::EacCli::Docopt::DocBuilder.new(self.class.runner_definition).to_s
      end

      def docopt_options
        super.merge(options_first: self.class.runner_definition.options_first?)
      end
    end
  end
end
