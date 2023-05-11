# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    module DefaultValue
      def default_value
        default_value? ? options[OPTION_DEFAULT] : default_default_value
      end

      def default_value?
        options.key?(OPTION_DEFAULT)
      end
    end
  end
end
