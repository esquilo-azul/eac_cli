# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'optparse'

module EacCli
  class Parser
    class OptionsCollection
      SEP = ' '
      IDENT = SEP * 2
      OPTION_DESC_SEP = IDENT * 2

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
        option_parser.banner = "#{definition.description}\n\n#{section('usage')}"
      end

      def build_options
        definition.options.each do |option|
          build_option(option)
        end
      end

      def build_option(option)
        option_parser.on(
          *[option_short(option), option_long(option), option.description].reject(&:blank?)
        ) do |value|
          collector.collect(option, value)
        end
      end

      def positional_argument(positional)
        if positional.subcommand?
          ::EacRubyUtils::Console::DocoptRunner::SUBCOMMANDS_MACRO
        else
          r = "<#{positional.name}>"
          r += '...' if positional.repeat?
          r = "[#{r}]" if positional.optional?
          r
        end
      end

      def option_argument(option)
        option_long(option)
      end

      def option_long(option)
        b = option.long
        b += '=VALUE' if option.argument?
        b
      end

      def option_short(option)
        b = option.short
        b += 'VALUE' if option.argument?
        b
      end

      def section(header, include_header = true)
        b = include_header ? "#{header.humanize}:\n" : ''
        b += send("self_#{header}") + "\n"
        # TO-DO: implement alternatives
        b
      end

      def self_options
        definition.options.map { |option| IDENT + option_definition(option) }.join("\n")
      end

      def self_usage
        IDENT + self_usage_arguments.join(SEP)
      end

      def self_usage_arguments
        [::EacRubyUtils::Console::DocoptRunner::PROGRAM_MACRO] +
          definition.options_argument.if_present([]) { |_v| ['[options]'] } +
          self_usage_arguments_options +
          self_usage_arguments_positional
      end

      def self_usage_arguments_options
        definition.options.select(&:show_on_usage?).map { |option| option_argument(option) }
      end

      def self_usage_arguments_positional
        definition.positional.map { |p| positional_argument(p) }
      end
    end
  end
end
