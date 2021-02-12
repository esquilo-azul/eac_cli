# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class BooleanOption < ::EacCli::Definition::BaseOption
      def argument?
        false
      end

      def build_value(_new_value, previous_value)
        repeat? ? previous_value + 1 : true
      end

      def default_value
        repeat? ? 0 : false
      end
    end
  end
end
