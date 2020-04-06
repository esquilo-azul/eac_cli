# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/console/docopt_runner'

module EacCli
  module Runner
    class DocoptDoc
      common_constructor :definition

      SEP = ' '
      IDENT = SEP * 2
      OPTION_DESC_SEP = IDENT * 2

      def positional_argument(positional)
        r = "<#{positional.name}>"
        r += '...' if positional.repeat?
        r
      end

      def option_argument(option)
        option_long(option)
      end

      def option_definition(option)
        option.short + SEP + option_long(option) + OPTION_DESC_SEP + option.description
      end

      def option_long(option)
        b = option.long
        b += '=<value>' if option.argument?
        b
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
        b = IDENT + ::EacRubyUtils::Console::DocoptRunner::PROGRAM_MACRO
        b += "#{SEP}[options]" if definition.options_argument
        b + self_usage_arguments
      end

      def self_usage_arguments
        definition.options.select(&:show_on_usage?)
                  .map { |option| "#{SEP}#{option_argument(option)}" }.join +
          definition.positional.map { |p| "#{SEP}#{positional_argument(p)}" }.join
      end

      def to_s
        "#{definition.description}\n\n#{section('usage')}\n#{section('options')}\n"
      end
    end
  end
end
