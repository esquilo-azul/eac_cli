# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  class Parser
    class Alternative
      module AnyOptions
        delegate :any_option?, to: :alternative

        # @return [EacCli::Definition::BooleanOption] if #any_option? is true.
        # @raise [EacCli::Parser::Error] if #any_option? is false.
        def any_option_collect_option
          any_option? ? alternative.any_options_option : raise_argv_current_invalid_option
        end
      end
    end
  end
end
