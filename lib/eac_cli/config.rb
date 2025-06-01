# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  class Config < ::SimpleDelegator
    require_sub __FILE__

    def entry(path, options = {})
      ::EacCli::Config::Entry.new(self, path, options)
    end

    def sub
      __getobj__
    end
  end
end
