# frozen_string_literal: true

require 'eac_cli/parser/collector'
require 'eac_cli/parser/error'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Parser
    class Alternative
      require_sub __FILE__, include_modules: true
      enable_listable
      lists.add_symbol :phase, :any, :option_argument, :positional
      attr_reader :error

      common_constructor :alternative, :argv do
        alternative.assert_argument(::EacCli::Definition::Alternative, :alternative)
        self.phase = PHASE_ANY
        collect
      end

      def error?
        error.present?
      end

      def success?
        !error?
      end

      def parsed
        @parsed ||= collector.to_data.freeze
      end

      private

      attr_accessor :phase

      def any_collect_argv_value
        %w[double_dash long_option option].each do |arg_type|
          return send("#{arg_type}_collect_argv_value") if send("argv_current_#{arg_type}?")
        end

        positional_collect_argv_value
      end

      def collector
        @collector ||= ::EacCli::Parser::Collector.new(alternative)
      end

      def collect
        loop do
          break unless argv_pending?

          collect_argv_value
        end
        validate
      rescue ::EacCli::Parser::Error => e
        @error = e
      end

      def collect_argv_value
        send("#{phase}_collect_argv_value")
        argv_enum.next
      end

      def collect_option_argv_value
        alternative.options.each do |option|
        end

        raise ::EacCli::Parser::Error.new(
          alternative, argv, "Invalid option: #{argv_enum.current}"
        )
      end

      def raise_error(message)
        raise ::EacCli::Parser::Error.new(alternative, argv, message)
      end

      def validate
        (alternative.options + alternative.positional).each do |option|
          validate_option(option)
        end
      end

      def validate_option(option)
        return unless option.required?
        return if collector.supplied?(option)

        raise_error("Required option/positional #{option} not supplied")
      end
    end
  end
end
