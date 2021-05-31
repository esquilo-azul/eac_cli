# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Config
    class Entry
      require_sub __FILE__, include_modules: true
      enable_listable
      enable_simple_cache
      include ::EacCli::Speaker

      common_constructor :config, :path, :options do
        self.path = ::EacConfig::EntryPath.assert(path)
        self.options = ::EacCli::Config::Entry::Options.new(options)
      end

      def value
        return sub_value_to_return if sub_entry.found?
        return nil unless options.required?

        puts "|#{sub_entry.path}|"

        input_value
      end

      private

      def sub_value_to_return
        sub_entry.value.presence || ::EacRubyUtils::BlankNotBlank.instance
      end

      def sub_entry_uncached
        config.sub.entry(path)
      end

      def input_value_uncached
        r = send("#{options.type}_value")
        sub_entry.value = r if options.store?
        r
      end
    end
  end
end
