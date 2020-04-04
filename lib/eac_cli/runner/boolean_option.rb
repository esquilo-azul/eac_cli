# frozen_string_literal: true

require 'eac_cli/runner/base_option'

module EacCli
  module Runner
    class BooleanOption < ::EacCli::Runner::BaseOption
      def argument?
        false
      end
    end
  end
end
