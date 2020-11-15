# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'optparse'

module EacCli
  class Parser
    class OptionsCollection
      enable_simple_cache
      common_constructor(:definition, :argv, :collector) { collect }
      attr_reader :arguments

      def options_first?
        definition.options_first? || definition.subcommands?
      end

      private

      def check_required_options
        definition.options.each do |option|
          next unless option.required?
          next if collector.supplied?(option)

          raise ::EacCli::Parser::Error.new(
            definition, argv, "Option \"#{option}\" is required and a value was not supplied"
          )
        end
      end

      def collect
        build_banner
        build_options
        parse_argv
        check_required_options
      end

      def option_parser_uncached
        ::OptionParser.new
      end

      def parse_argv
        @arguments = options_first? ? option_parser.order(argv) : option_parser.parse(argv)
      rescue ::OptionParser::InvalidOption => e
        raise ::EacCli::Parser::Error.new(definition, argv, e.message)
      end

      def build_banner
        option_parser.banner = definition.help_formatter.to_banner
      end

      def build_options
        definition.options.each do |option|
          build_option(option)
        end
      end

      def build_option(option)
        option_parser.on(
          *[::EacCli::Definition::HelpFormatter.option_short(option),
            ::EacCli::Definition::HelpFormatter.option_long(option),
            option.description].reject(&:blank?)
        ) do |value|
          collector.collect(option, value)
        end
      end
    end
  end
end
