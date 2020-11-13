# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class PositionalArgument
      enable_listable
      lists.add_symbol :option, :optional, :repeat, :subcommand
      common_constructor :name, :options, default: [{}] do
        options.assert_valid_keys(self.class.lists.option.values)
      end

      def identifier
        name.to_s.variableize.to_sym
      end

      def optional?
        options[OPTION_OPTIONAL]
      end

      def repeat?
        options[OPTION_REPEAT]
      end

      def subcommand?
        options[OPTION_SUBCOMMAND]
      end
    end
  end
end
