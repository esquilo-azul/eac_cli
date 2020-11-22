# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module Positionals
        private

        def positional_collect_argv_value
          positional_check
          collector.collect(positional_enum.peek, argv_enum.peek)
          positional_next
        end

        def positional_enum
          @positional_enum ||= alternative.positional.each
        end

        def positional_check
          raise_error("Invalid positional: #{argv_enum.peek}") if positional_enum.stopped?
        end

        def positional_next
          self.phase = PHASE_POSITIONAL if positional_enum.peek.subcommand?
          positional_enum.next unless positional_enum.peek.repeat?
        end
      end
    end
  end
end
