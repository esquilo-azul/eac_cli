# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class BaseOption
      DEFAULT_REQUIRED = false

      enable_listable
      enable_abstract_methods :default_value
      lists.add_symbol :option, :optional, :usage, :required
      attr_reader :short, :long, :description, :options

      def initialize(short, long, description, options = {})
        @short = short
        @long = long
        @description = description
        @options = options.symbolize_keys
        @options.assert_valid_keys(::EacCli::Definition::BaseOption.lists.option.values)
      end

      def identifier
        long.to_s.variableize.to_sym
      end

      def required?
        return true if options.key?(:required) && options.fetch(:required)
        return false if options.key?(:optional) && options.fetch(:optional)

        DEFAULT_REQUIRED
      end

      def to_s
        "#{self.class.name.demodulize}[#{identifier}]"
      end

      def show_on_usage?
        options[:usage]
      end
    end
  end
end
