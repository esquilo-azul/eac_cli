# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module LongOptions
        LONG_OPTION_PREFIX = '--'

        private

        def argv_current_long_option?
          phase == PHASE_ANY && argv_enum.peek.start_with?(LONG_OPTION_PREFIX) &&
            !argv_current_double_dash?
        end

        def long_option_collect_argv_value
          alternative.options.any? do |option|
            next false unless option.long == argv_enum.peek

            option_collect_option(option)
          end || raise_argv_current_invalid_option
        end
      end
    end
  end
end
