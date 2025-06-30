# frozen_string_literal: true

module EacCli
  module RunnerWith
    module Confirmation
      class InputResult
        INPUT_NO_FOR_ONE = 'n'
        INPUT_NO_FOR_ALL = 'N'
        INPUT_YES_FOR_ONE = 'y'
        INPUT_YES_FOR_ALL = 'Y'
        INPUT_FOR_ONE = [INPUT_NO_FOR_ONE, INPUT_YES_FOR_ONE].freeze
        INPUT_FOR_ALL = [INPUT_NO_FOR_ALL, INPUT_YES_FOR_ALL].freeze
        INPUT_NO = [INPUT_NO_FOR_ONE, INPUT_NO_FOR_ALL].freeze
        INPUT_YES = [INPUT_YES_FOR_ONE, INPUT_YES_FOR_ALL].freeze
        INPUT_LIST = [INPUT_NO_FOR_ALL, INPUT_NO_FOR_ONE, INPUT_YES_FOR_ONE, INPUT_YES_FOR_ALL]
                       .freeze

        class << self
          enable_speaker

          # @param message [String]
          # @return [EacCli::RunnerWith::Confirmation::InputResult]
          def by_message(message)
            new(input_value_by_speaker(message))
          end

          # @param message [String]
          # @return [String]
          def input_value_by_speaker(message)
            input(message, list: INPUT_LIST, ignore_case: false)
          end
        end

        common_constructor :input_value

        # @return [Boolean]
        def confirm?
          input_value_to_bool(INPUT_NO, INPUT_YES)
        end

        # @return [Boolean]
        def for_all?
          input_value_to_bool(INPUT_FOR_ONE, INPUT_FOR_ALL)
        end

        private

        # @param false_list [Array<String>]
        # @param true_list [Array<String>]
        # @return [Boolean]
        def input_value_to_bool(false_list, true_list)
          return false if false_list.include?(input_value)
          return true if true_list.include?(input_value)

          ibr input_value
        end
      end
    end
  end
end
