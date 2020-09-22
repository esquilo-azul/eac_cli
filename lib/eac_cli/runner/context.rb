# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    class Context
      attr_reader :argv, :parent, :program_name

      def initialize(*context_args)
        options = context_args.extract_options!
        @argv = (context_args[0] || options.delete(:argv) || ARGV).dup.freeze
        @parent = context_args[1] || options.delete(:parent)
        @program_name = options.delete(:program_name)
      end
    end
  end
end
