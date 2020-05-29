# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class PositionalArgument
      common_constructor :name, :options, default: [{}]

      def identifier
        name.to_s.variableize.to_sym
      end

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
