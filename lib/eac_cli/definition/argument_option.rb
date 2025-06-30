# frozen_string_literal: true

module EacCli
  class Definition
    class ArgumentOption < ::EacCli::Definition::Option
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
