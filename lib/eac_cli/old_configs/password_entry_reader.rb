# frozen_string_literal: true

module EacCli
  class OldConfigs
    class PasswordEntryReader < ::EacCli::OldConfigs::EntryReader
      ENTRY_KEY = 'core.store_passwords'

      def initialize(console_configs, entry_key, options = {})
        super(console_configs, entry_key, options.merge(noecho: true,
                                                        store: console_configs.store_passwords?))
      end
    end
  end
end
