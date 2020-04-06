# frozen_string_literal: true

require 'eac_cli/runner/argument_option'
require 'eac_cli/runner/boolean_option'
require 'eac_cli/runner/positional_argument'
require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    class Definition
      require_sub __FILE__
      attr_accessor :description
      attr_accessor :options_argument

      def initialize
        self.description = '-- NO DESCRIPTION SET --'
        self.options_argument = true
      end

      def alt(&block)
        r = ::EacCli::Runner::Definition.new
        r.instance_eval(&block)
        alternatives << r
        r
      end

      def alternatives
        @alternatives ||= []
      end

      def arg_opt(short, long, description, option_options = {})
        options << ArgumentOption.new(short, long, description, option_options)
      end

      def bool_opt(short, long, description, option_options = {})
        options << BooleanOption.new(short, long, description, option_options)
      end

      def desc(description)
        self.description = description
      end

      def options_arg(options_argument)
        self.options_argument = options_argument
      end

      def options
        @options ||= []
      end

      def pos_arg(name, arg_options = {})
        positional << PositionalArgument.new(name, arg_options)
      end

      def positional
        @positional ||= []
      end
    end
  end
end
