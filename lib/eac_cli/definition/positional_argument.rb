# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class PositionalArgument
      DEFAULT_REQUIRED = true

      enable_listable
      lists.add_symbol :option, :optional, :repeat, :required, :subcommand
      common_constructor :name, :options, default: [{}] do
        options.assert_valid_keys(self.class.lists.option.values)
      end

      def identifier
        name.to_s.variableize.to_sym
      end

      def optional?
        !required?
      end

      def repeat?
        options[OPTION_REPEAT]
      end

      def required?
        return true if options.key?(OPTION_REQUIRED) && options.fetch(OPTION_REQUIRED)
        return false if options.key?(OPTION_OPTIONAL) && options.fetch(OPTION_OPTIONAL)

        DEFAULT_REQUIRED
      end

      def subcommand?
        options[OPTION_SUBCOMMAND]
      end
    end
  end
end
