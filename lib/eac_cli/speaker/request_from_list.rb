# frozen_string_literal: true

require 'eac_cli/speaker/list'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Speaker
    class RequestFromList
      acts_as_instance_method
      common_constructor :speaker, :question, :list_values, :noecho

      # @return [String]
      def result
        list = ::EacCli::Speaker::List.build(list_values)
        loop do
          input = speaker.send(
            :request_string,
            "#{question} [#{list.valid_labels.join('/')}]",
            noecho
          )
          return list.build_value(input) if list.valid_value?(input)

          speaker.warn "Invalid input: \"#{input}\" (Valid: #{list.valid_labels.join(', ')})"
        end
      end
    end
  end
end
