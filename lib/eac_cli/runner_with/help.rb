# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      common_concern do
        include ::EacCli::Runner

        runner_definition.alt do
          options_arg false
          bool_opt '-h', '--help', 'Show help.', usage: true
        end
      end
    end
  end
end
