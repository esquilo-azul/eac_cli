# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/console/docopt_runner'

module EacCli
  module Docopt
    class DocBuilder
      class Alternative
        common_constructor :alternative

        def to_s
          (
            [::EacRubyUtils::Console::DocoptRunner::PROGRAM_MACRO] +
              alternative.options_argument?.if_present([]) { |_v| ['[options]'] } +
              options +
              positionals
          ).join(::EacCli::Docopt::DocBuilder::SEP)
        end

        def options
          alternative.options.select(&:show_on_usage?).map do |option|
            ::EacCli::Docopt::DocBuilder.option_long(option)
          end
        end

        def option_argument(option)
          b = option.long
          b += '=<value>' if option.argument?
          b
        end

        def positionals
          alternative.positional.map { |p| positional(p) }
        end

        def positional(positional)
          if positional.subcommand?
            ::EacRubyUtils::Console::DocoptRunner::SUBCOMMANDS_MACRO
          else
            r = "<#{positional.name}>"
            r += '...' if positional.repeat?
            r = "[#{r}]" if positional.optional?
            r
          end
        end
      end
    end
  end
end
