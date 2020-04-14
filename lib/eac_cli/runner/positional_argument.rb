# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    class PositionalArgument
      common_constructor :name, :options, default: [{}]

      def optional?
        options[:optional]
      end

      def repeat?
        options[:repeat]
      end

      def subcommand?
        options[:subcommand]
      end
    end
  end
end
