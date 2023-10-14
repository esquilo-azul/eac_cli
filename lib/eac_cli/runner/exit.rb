# frozen_string_literal: true

module EacCli
  module Runner
    class Exit < ::StandardError
      attr_reader :status

      def initialize(status = true)
        super
        @status = status
      end
    end
  end
end
