# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__ do
  ignore 'core_ext'
  ignore 'patches'
end

module EacCli
end

require 'eac_cli/core_ext'
