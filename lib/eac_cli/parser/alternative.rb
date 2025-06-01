# frozen_string_literal: true

require 'eac_cli/parser/collector'
require 'eac_cli/parser/error'
require 'eac_ruby_utils'

module EacCli
  class Parser
    class Alternative
      require_sub __FILE__, include_modules: true
      enable_listable
      lists.add_symbol :phase, :any, :option_argument, :positional

      # @return [EacCli::Parser::Error, nil]
      attr_reader :error

      # @!method initialize(alternative, argv)
      # @param alternative [EacCli::Definition::Alternative]
      # @param argv [Array<String>]
      common_constructor :alternative, :argv do
        alternative.assert_argument(::EacCli::Definition::Alternative, :alternative)
        self.phase = PHASE_ANY
        collect
      end

      # @return [Boolean]
      def error?
        error.present?
      end

      # @return [Boolean]
      def success?
        !error?
      end

      # @return [EacRubyUtils::Struct]
      def parsed
        @parsed ||= collector.to_data.freeze
      end

      private

      # @return [Symbol]
      attr_accessor :phase

      # @return [void]
      def any_collect_argv_value
        %w[double_dash long_option short_option].each do |arg_type|
          return send("#{arg_type}_collect_argv_value") if send("argv_current_#{arg_type}?")
        end

        positional_collect_argv_value
      end

      # @return [EacCli::Parser::Collector]
      def collector
        @collector ||= ::EacCli::Parser::Collector.new(alternative)
      end

      # @return [void]
      def collect
        loop do
          break unless argv_pending?

          collect_argv_value
        end
        validate
      rescue ::EacCli::Parser::Error => e
        @error = e
      end

      # @return [void]
      def collect_argv_value
        send("#{phase}_collect_argv_value")
        argv_enum.next
      end

      # @param message [String]
      # @raise [EacCli::Parser::Error] Always.
      def raise_error(message)
        raise ::EacCli::Parser::Error.new(alternative, argv, message)
      end

      # @return [void]
      # @raise [EacCli::Parser::Error] If options where not properly supplied.
      def validate
        (alternative.options + alternative.positional).each do |option|
          validate_option(option)
        end
      end

      # @param option [EacCli::Definition::Option, EacCli::Definition::Positional]
      # @return [void]
      # @raise [EacCli::Parser::Error] If option was not properly supplied.
      def validate_option(option)
        return unless option.required?
        return if collector.supplied?(option)

        raise_error("Required option/positional #{option} not supplied")
      end
    end
  end
end
