# frozen_string_literal: true

require 'eac_cli/speaker/input_requested'

module EacCli
  class Speaker
    class InputBlocked
      %w[gets noecho].each do |method|
        define_method(method) do
          raise ::EacCli::Speaker::InputRequested,
                "Method (\"#{method}\") was requested, but input is blocked"
        end
      end
    end
  end
end
