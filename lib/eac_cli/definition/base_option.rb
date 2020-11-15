# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class BaseOption
      enable_listable
      lists.add_symbol :option, :usage
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

      def show_on_usage?
        options[:usage]
      end
    end
  end
end
