# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module Options
        private

        attr_accessor :argument_option

        def argument_option_collect_argv(option)
          self.argument_option = option
          self.phase = PHASE_OPTION_ARGUMENT
        end

        def argv_current_option?
          phase == PHASE_ANY && argv_enum.peek.start_with?('-')
        end

        def boolean_option_collect_argv(option)
          collector.collect(option, true)
        end

        def option_argument_collect_argv_value
          collector.collect(argument_option, argv_enum.peek)
          self.argument_option = nil
          self.phase = PHASE_ANY
        end

        def option_collect_argv_value
          return double_dash_collect_argv_value if argv_current_double_dash?

          alternative.options.any? do |option|
            next false unless [option.short, option.long].include?(argv_enum.peek)

            if option.argument?
              argument_option_collect_argv(option)
            else
              boolean_option_collect_argv(option)
            end

            true
          end || raise_argv_current_invalid_option
        end

        def raise_argv_current_invalid_option
          raise_error "Invalid option: \"#{argv_enum.peek}\""
        end
      end
    end
  end
end
