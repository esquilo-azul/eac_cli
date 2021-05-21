# frozen_string_literal: true

require 'eac_cli/runner_with/help'
require 'eac_ruby_utils/core_ext'

module EacCli
  module DefaultRunner
    common_concern do
      include ::EacCli::RunnerWith::Help
      enable_speaker
      enable_simple_cache
    end
  end
end
