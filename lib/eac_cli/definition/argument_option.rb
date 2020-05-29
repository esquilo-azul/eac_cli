# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class ArgumentOption < ::EacCli::Definition::BaseOption
      def argument?
        true
      end
    end
  end
end
