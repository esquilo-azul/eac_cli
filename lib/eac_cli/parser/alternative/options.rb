# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module Options
        private

        def argv_current_option?
          phase == PHASE_ANY && argv_enum.peek.start_with?('-')
        end

        def boolean_option_collect_argv(option)
          collector.collect(option, true)
        end

        def option_collect_argv_value
          alternative.options.any? do |option|
            next false unless option.short == argv_enum.peek

            option_collect_option(option)
          end || raise_argv_current_invalid_option
        end

        def option_collect_option(option)
          if option.argument?
            argument_option_collect_argv(option)
          else
            boolean_option_collect_argv(option)
          end

          option
        end

        def raise_argv_current_invalid_option
          raise_error "Invalid option: \"#{argv_enum.peek}\""
        end
      end
    end
  end
end
