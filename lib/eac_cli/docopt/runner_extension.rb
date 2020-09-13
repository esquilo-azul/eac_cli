# frozen_string_literal: true

require 'eac_cli/docopt/doc_builder'
require 'eac_ruby_utils/console/docopt_runner'

module EacCli
  module Docopt
    module RunnerExtension
      extend ::ActiveSupport::Concern

      included do
        singleton_class.prepend ClassMethods
        prepend InstanceMethods
      end

      class << self
        def check(klass)
          return unless klass < ::EacRubyUtils::Console::DocoptRunner

          klass.include(self)
        end
      end

      module ClassMethods
        def create(*context_args)
          r = new(*context_args)
          r.context = ::EacCli::Runner::Context.new(*context_args)
          r
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

      def extra_available_subcommands
        self.class.constants
            .map { |name| self.class.const_get(name) }
            .select { |c| c.instance_of? Class }
            .select { |c| c.included_modules.include?(::EacCli::Runner) }
            .map { |c| c.name.demodulize.underscore.dasherize }
      end
    end
  end
end
