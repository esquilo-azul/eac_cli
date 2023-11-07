# frozen_string_literal: true

require 'eac_cli/definition/option_or_positional'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class Positional < ::EacCli::Definition::OptionOrPositional
      DEFAULT_REQUIRED = true
      DEFAULT_VISIBLE = true

      lists.add_symbol :option, *OPTION_LIST, :subcommand, :visible

      # @!method initialize(name, options = {})
      # @param name [String]
      # @param options [Hash<Symbol, Object>]
      common_constructor :name, :options, default: [{}] do
        options.assert_valid_keys(self.class.lists.option.values)
      end

      # @param new_value [Array, Object]
      # @param previous_value [Array, Object]
      # @return [Array]
      def build_value(new_value, previous_value)
        if previous_value.is_a?(::Array)
          previous_value + [new_value]
        else
          new_value
        end
      end

      # @return [Object]
      def default_value
        repeat? ? [] : nil
      end

      # @return [Symbol]
      def identifier
        name.to_s.variableize.to_sym
      end

      # @return [Boolean]
      def subcommand?
        options[OPTION_SUBCOMMAND]
      end

      # @return [Boolean]
      def visible?
        options.key?(OPTION_VISIBLE) ? options.fetch(OPTION_VISIBLE) : DEFAULT_VISIBLE
      end
    end
  end
end
