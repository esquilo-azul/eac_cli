# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Config < ::SimpleDelegator
    require_sub __FILE__

    def initialize(sub_node)
      super(sub_node)
    end

    def entry(path, options = {})
      ::EacCli::Config::Entry.new(self, path, options)
    end

    def sub
      __getobj__
    end
  end
end
