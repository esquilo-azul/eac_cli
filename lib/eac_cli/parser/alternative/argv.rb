# frozen_string_literal: true

module EacCli
  class Parser
    class Alternative
      module Argv
        def argv_enum
          @argv_enum ||= argv.each
        end

        def argv_pending?
          argv_enum.ongoing?
        end
      end
    end
  end
end
