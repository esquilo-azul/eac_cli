# frozen_string_literal: true

require 'eac_cli/runner/base_option'

module EacCli
  module Runner
    class ArgumentOption < ::EacCli::Runner::BaseOption
      def argument?
        true
      end
    end
  end
end
