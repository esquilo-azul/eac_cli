# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class HelpFormatter
      SEP = ' '
      IDENT = SEP * 2
      OPTION_DESC_SEP = IDENT * 2

      class << self
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
      end

      common_constructor :definition

      def option_argument(option)
        b = option.long
        b += '=VALUE' if option.argument?
        b
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
        definition.options.select(&:show_on_usage?).map do |option|
          self.class.option_argument(option)
        end
      end

      def self_usage_arguments_positional
        definition.positional.map { |p| positional_argument(p) }
      end

      def to_banner
        "#{definition.description}\n\n#{section('usage')}"
      end
    end
  end
end
