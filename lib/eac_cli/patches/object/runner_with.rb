# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/runner'
require 'eac_cli/runner_with'

class Object
  def runner_with(*runners)
    include ::EacCli::Runner
    enable_simple_cache
    enable_console_speaker
    runners.each do |runner|
      include runner_with_to_module(runner)
    end
  end

  private

  def runner_with_to_module(runner)
    return runner if runner.is_a?(::Module)

    "EacCli::RunnerWith::#{runner.to_s.camelize}".constantize
  end
end
