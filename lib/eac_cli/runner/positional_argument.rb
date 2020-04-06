# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    class PositionalArgument
      common_constructor :name, :options, default: [{}]

      def repeat?
        options[:repeat]
      end
    end
  end
end
