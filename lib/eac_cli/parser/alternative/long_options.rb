# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module LongOptions
        LONG_OPTION_PREFIX = '--'
        OPTION_WITH_ARGUMENT_PATTERN = /\A([^=]+)(?:=(.*))\z/.freeze

        private

        def argv_current_long_option?
          phase == PHASE_ANY && argv_enum.peek.start_with?(LONG_OPTION_PREFIX) &&
            !argv_current_double_dash?
        end

        def long_option_collect_argv_value
          option_long, value = parse_option_current_argv
          alternative.options.any? do |option|
            next false unless option.long == option_long

            if value.nil?
              option_collect_option(option)
            else
              option_argument_collect(option, value)
            end
          end || raise_argv_current_invalid_option
        end

        def parse_option_current_argv
          m = OPTION_WITH_ARGUMENT_PATTERN.match(argv_enum.peek)
          m ? [m[1], m[2].if_present('')] : [argv_enum.peek, nil]
        end
      end
    end
  end
end
