# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class BooleanOption < ::EacCli::Definition::BaseOption
      def argument?
        false
      end
    end
  end
end
