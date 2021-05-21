# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/patch'

class Module
  def enable_speaker
    ::EacRubyUtils.patch(self, ::EacCli::Speaker)
  end
end
