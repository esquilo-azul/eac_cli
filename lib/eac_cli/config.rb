# frozen_string_literal: true

require 'eac_config/envvars_node'
require 'eac_config/yaml_file_node'

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
