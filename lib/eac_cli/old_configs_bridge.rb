# frozen_string_literal: true

require 'eac_cli/config'
require 'eac_ruby_utils/core_ext'

module EacCli
  class OldConfigsBridge < ::EacCli::Config
    ENTRY_KEY = 'core.store_passwords'

    class << self
      def new_configs_path(configs_key, options)
        options[:storage_path] || ::File.join(ENV['HOME'], '.config', configs_key, 'settings.yml')
      end
    end

    def initialize(configs_key, options = {})
      options.assert_argument(::Hash, 'options')
      envvar_node = ::EacConfig::EnvvarsNode.new
      file_node = ::EacConfig::YamlFileNode.new(self.class.new_configs_path(configs_key, options))
      envvar_node.load_path.push(file_node.url)
      envvar_node.write_node = file_node
      super(envvar_node)
    end

    def read_entry(entry_key, options = {})
      entry(entry_key, options).value
    end

    def read_password(entry_key, options = {})
      entry(entry_key, options.merge(noecho: true, store: store_passwords?)).value
    end

    def store_passwords?
      read_entry(ENTRY_KEY, bool: true)
    end
  end
end
