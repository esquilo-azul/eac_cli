# frozen_string_literal: true

require 'active_support/concern'
require 'eac_cli/runner'
require 'eac_ruby_utils/console/speaker'
require 'eac_ruby_utils/simple_cache'

module EacCli
  module DefaultRunner
    extend ::ActiveSupport::Concern

    included do
      include ::EacCli::Runner
      include ::EacRubyUtils::Console::Speaker
      include ::EacRubyUtils::SimpleCache
      runner_definition.alt do
        options_arg false
        bool_opt '-h', '--help', 'Show help.', usage: true
      end
    end
  end
end
