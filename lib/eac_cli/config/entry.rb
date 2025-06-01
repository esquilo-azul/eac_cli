# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_config/entry_path'
require 'eac_config/node_entry'
require 'eac_ruby_utils'

module EacCli
  class Config < ::SimpleDelegator
    class Entry < ::EacConfig::NodeEntry
      require_sub __FILE__, include_modules: true
      enable_listable
      enable_simple_cache
      enable_speaker

      common_constructor :root_node, :path, :options, super_args: -> { [root_node, path] } do
        self.options = ::EacCli::Config::Entry::Options.new(options)
      end

      # @return [EacCli::Config]
      def config
        root_node
      end

      # @return [Object, nil]
      def value
        sub_entry.found? ? sub_value_to_return : nil
      end

      def value!
        return sub_value_to_return if sub_entry.found?
        return nil unless options.required?

        input_value
      end

      def secret_value
        self.class.new(config, path, options.to_h.merge(noecho: true).to_h).value
      end

      delegate :found?, :value=, to: :sub_entry

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
