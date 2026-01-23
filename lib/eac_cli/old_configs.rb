# frozen_string_literal: true

module EacCli
  class OldConfigs
    enable_speaker

    class << self
      delegate :entry_key_to_envvar_name, to: :'::EacCli::OldConfigs::EntryReader'
    end

    attr_reader :configs

    def initialize(configs_key, options = {})
      options.assert_argument(::Hash, 'options')
      @configs = ::EacConfig::OldConfigs.new(configs_key, options.merge(autosave: true))
    end

    def read_password(entry_key, options = {})
      ::EacCli::OldConfigs::PasswordEntryReader.new(self, entry_key, options).read
    end

    def read_entry(entry_key, options = {})
      ::EacCli::OldConfigs::EntryReader.new(self, entry_key, options).read
    end

    def store_passwords?
      ::EacCli::OldConfigs::StorePasswordsEntryReader.new(self) == 'yes'
    end
  end
end
