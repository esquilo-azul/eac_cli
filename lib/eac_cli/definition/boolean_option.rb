# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class BooleanOption < ::EacCli::Definition::BaseOption
      def argument?
        false
      end

      def build_value(_new_value, _previous_value)
        true
      end

      def default_value
        false
      end
    end
  end
end
