# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class Positional
      DEFAULT_REQUIRED = true
      DEFAULT_VISIBLE = true

      enable_listable
      lists.add_symbol :option, :optional, :repeat, :required, :subcommand, :visible

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
      def optional?
        !required?
      end

      # @return [Boolean]
      def repeat?
        options[OPTION_REPEAT]
      end

      # @return [Boolean]
      def required?
        return true if options.key?(OPTION_REQUIRED) && options.fetch(OPTION_REQUIRED)
        return false if options.key?(OPTION_OPTIONAL) && options.fetch(OPTION_OPTIONAL)

        DEFAULT_REQUIRED
      end

      # @return [Boolean]
      def subcommand?
        options[OPTION_SUBCOMMAND]
      end

      # @return [String]
      def to_s
        "#{self.class.name.demodulize}[#{identifier}]"
      end

      # @return [Boolean]
      def visible?
        options.key?(OPTION_VISIBLE) ? options.fetch(OPTION_VISIBLE) : DEFAULT_VISIBLE
      end
    end
  end
end
