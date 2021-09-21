# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class ArgumentOption < ::EacCli::Definition::BaseOption
      def argument?
        true
      end

      def build_value(new_value, previous_value)
        repeat? ? previous_value + [new_value] : new_value
      end

      def default_default_value
        repeat? ? [] : nil
      end
    end
  end
end
