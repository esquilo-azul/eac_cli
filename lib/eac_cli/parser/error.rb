# frozen_string_literal: true

require 'eac_ruby_utils'

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
