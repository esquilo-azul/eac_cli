# frozen_string_literal: true

require 'eac_ruby_utils/settings_provider'

module EacCli
  class DocoptRunner
    include ::EacRubyUtils::SettingsProvider

    attr_reader :settings

    private

    def setting_value(key, required = true)
      super(key, required: required, order: %w[method settings_object constant])
    end
  end
end
