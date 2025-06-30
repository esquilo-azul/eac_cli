# frozen_string_literal: true

module EacCli
  class Parser
    class Error < ::StandardError
      def initialize(definition, argv, message)
        @definition = definition
        @argv = argv
        super(message)
      end
    end
  end
end
