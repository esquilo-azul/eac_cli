# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/runner'
require 'eac_cli/runner_with'
require 'eac_cli/runner_with_set'

class Object
  def runner_with(*runners, &block)
    include ::EacCli::Runner
    enable_simple_cache
    enable_speaker
    runners.each do |runner|
      include ::EacCli::RunnerWithSet.default.item_to_module(runner)
    end
    runner_definition(&block) if block
  end

  private

  def runner_with_to_module(runner)
    return runner if runner.is_a?(::Module)

    "EacCli::RunnerWith::#{runner.to_s.camelize}".constantize
  end
end
