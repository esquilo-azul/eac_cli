# frozen_string_literal: true

require 'eac_cli/old_configs/read_entry_options'
require 'eac_config/paths_hash'
require 'eac_ruby_utils/core_ext'

module EacCli
  class OldConfigs
    class EntryReader
      enable_speaker

      class << self
        def entry_key_to_envvar_name(entry_key)
          path = if entry_key.is_a?(::Array)
                   entry_key
                 else
                   ::EacConfig::PathsHash.parse_entry_key(entry_key)
                 end
          path.join('_').gsub(/[^a-z0-9_]/i, '').gsub(/\A_+/, '').gsub(/_+\z/, '')
              .gsub(/_{2,}/, '_').upcase
        end
      end

      common_constructor :console_configs, :entry_key, :options do
        self.options = ::EacCli::OldConfigs::ReadEntryOptions.new(options)
      end

      def read
        %w[envvars storage console].each do |suffix|
          value = send("read_from_#{suffix}")
          return value if value.present?
        end
        return nil unless options[:required]

        raise "No value found for entry \"#{entry_key}\""
      end

      def read_from_storage
        console_configs.configs.read_entry(entry_key)
      end

      def read_from_envvars
        return if options[:noenv]

        env_entry_key = self.class.entry_key_to_envvar_name(entry_key)
        return unless ENV.key?(env_entry_key)

        ENV.fetch(env_entry_key).if_present(::EacRubyUtils::BlankNotBlank.instance)
      end

      def read_from_console
        return if options[:noinput]

        options[:before_input].if_present(&:call)
        entry_value = looped_entry_value_from_input
        console_configs.configs.write_entry(entry_key, entry_value) if options[:store]
        entry_value
      end

      private

      def looped_entry_value_from_input
        loop do
          entry_value = entry_value_from_input(entry_key, options)
          next if entry_value.blank?
          next if options[:validator] && !options[:validator].call(entry_value)

          return entry_value
        end
      end

      def entry_value_from_input(entry_key, options)
        entry_value = input("Value for entry \"#{entry_key}\"",
                            options.request_input_options)
        warn('Entered value is blank') if entry_value.blank?
        entry_value
      end
    end
  end
end
