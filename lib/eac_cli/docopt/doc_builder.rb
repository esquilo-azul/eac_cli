# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/console/docopt_runner'

module EacCli
  module Docopt
    class DocBuilder
      common_constructor :definition

      SEP = ' '
      IDENT = SEP * 2
      OPTION_DESC_SEP = IDENT * 2

      class << self
        def option_long(option)
          b = option.long
          b += '=<value>' if option.argument?
          b
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

      def option_definition(option)
        option.short + SEP + self.class.option_long(option) + OPTION_DESC_SEP + option.description
      end

      def section(header, include_header = true)
        b = include_header ? "#{header.humanize}:\n" : ''
        b += send("self_#{header}") + "\n"
        definition.alternatives.each do |alternative|
          b += self.class.new(alternative).section(header, false)
        end
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

      def to_s
        "#{definition.description}\n\n#{section('usage')}\n#{section('options')}\n"
      end
    end
  end
end
