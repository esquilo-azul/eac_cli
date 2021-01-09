# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module OptionArgument
        private

        attr_accessor :argument_option

        def argument_option_collect_argv(option)
          self.argument_option = option
          self.phase = PHASE_OPTION_ARGUMENT
        end

        def option_argument_collect_argv_value
          collector.collect(argument_option, argv_enum.peek)
          self.argument_option = nil
          self.phase = PHASE_ANY
        end
      end
    end
  end
end
