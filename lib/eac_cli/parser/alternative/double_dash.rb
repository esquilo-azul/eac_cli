# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module DoubleDash
        DOUBLE_DASH = '--'

        private

        attr_accessor :double_dash

        def argv_current_double_dash?
          argv_enum.peek == DOUBLE_DASH && !double_dash
        end

        def double_dash_collect_argv_value
          self.phase = PHASE_POSITIONAL
          self.double_dash = true
        end
      end
    end
  end
end
