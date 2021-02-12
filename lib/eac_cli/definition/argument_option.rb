# frozen_string_literal: true

require 'eac_cli/definition/base_option'

module EacCli
  class Definition
    class ArgumentOption < ::EacCli::Definition::BaseOption
      def argument?
        true
      end

      def build_value(new_value, _previous_value)
        new_value
      end

      def default_value
        nil
      end
    end
  end
end
