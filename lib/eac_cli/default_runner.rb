# frozen_string_literal: true

module EacCli
  module DefaultRunner
    common_concern do
      include ::EacCli::RunnerWith::Help

      enable_speaker
      enable_simple_cache
    end
  end
end
