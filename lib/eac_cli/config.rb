# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Config
    require_sub __FILE__
    attr_reader :sub

    def initialize(sub_node)
      @sub = sub_node
    end

    def entry(path, options = {})
      ::EacCli::Config::Entry.new(self, path, options)
    end
  end
end
