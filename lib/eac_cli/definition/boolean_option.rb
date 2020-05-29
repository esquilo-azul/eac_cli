# frozen_string_literal: true

require 'eac_cli/runner/base_option'

module EacCli
  class Definition
    class BooleanOption < ::EacCli::Runner::BaseOption
      def argument?
        false
      end
    end
  end
end
