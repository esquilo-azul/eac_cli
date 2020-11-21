# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/console/docopt_runner'

module EacCli
  module Docopt
    class DocBuilder
      require_sub __FILE__
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

      def option_definition(option)
        option.short + SEP + self.class.option_long(option) + OPTION_DESC_SEP + option.description
      end

      def section(header, include_header = true)
        b = include_header ? "#{header.humanize}:\n" : ''
        b += send("self_#{header}") + "\n"
        definition.alternatives.each do |alternative|
          b += IDENT + ::EacCli::Docopt::DocBuilder::Alternative.new(alternative).to_s + "\n"
        end
        b
      end

      def options_section
        "Options:\n" +
          definition.alternatives.flat_map(&:options)
                    .map { |option| IDENT + option_definition(option) + "\n" }.join
      end

      def usage_section
        "Usage:\n" +
          definition.alternatives.map do |alternative|
            IDENT + ::EacCli::Docopt::DocBuilder::Alternative.new(alternative).to_s + "\n"
          end.join
      end

      def to_s
        "#{definition.description}\n\n#{usage_section}\n#{options_section}\n"
      end
    end
  end
end
