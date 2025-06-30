# frozen_string_literal: true

module EacCli
  class Speaker
    class RequestFromList
      acts_as_instance_method
      enable_simple_cache
      common_constructor :speaker, :question, :list_values, :noecho,
                         :ignore_case

      # @return [String]
      def result
        loop do
          return list.build_value(input) if list.valid_value?(input)

          speaker.warn "Invalid input: \"#{input}\" (Valid: #{list.valid_labels.join(', ')})"
        end
      end

      protected

      # @return [String]
      def input_uncached
        speaker.send(
          :request_string,
          "#{question} [#{list.valid_labels.join('/')}]",
          noecho
        )
      end

      # @return [EacCli::Speaker::List]
      def list_uncached
        list_options = {}
        list_options[::EacCli::Speaker::List::OPTION_IGNORE_CASE] = ignore_case unless
          ignore_case.nil?
        ::EacCli::Speaker::List.build(list_values, list_options)
      end
    end
  end
end
