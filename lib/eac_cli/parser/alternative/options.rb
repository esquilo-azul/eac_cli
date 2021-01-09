# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module Options
        private

        def boolean_option_collect_argv(option)
          collector.collect(option, true)
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
