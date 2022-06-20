# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      class Builder
        class Alternative
          enable_method_class

          PROGRAM_MACRO = '__PROGRAM__'
          SUBCOMMANDS_MACRO = '__SUBCOMMANDS__'

          common_constructor :builder, :alternative

          def result
            (
              [PROGRAM_MACRO] +
                alternative.options_argument?.if_present([]) { |_v| ['[options]'] } +
                options +
                positionals
            ).join(builder.word_separator)
          end

          def options
            alternative.options.select(&:show_on_usage?).map do |option|
              ::EacCli::RunnerWith::Help::Builder.option_long(option)
            end
          end

          def option_argument(option)
            b = option.long
            b += '=<value>' if option.argument?
            b
          end

          def positionals
            alternative.positional.map { |p| positional(p) }.reject(&:blank?)
          end

          def positional(positional)
            return unless positional.visible?

            if positional.subcommand?
              SUBCOMMANDS_MACRO
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
end
