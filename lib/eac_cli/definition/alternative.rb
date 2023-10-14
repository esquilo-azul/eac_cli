# frozen_string_literal: true

require 'eac_cli/definition/argument_option'
require 'eac_cli/definition/boolean_option'
require 'eac_cli/definition/positional_argument'

module EacCli
  class Definition
    class Alternative
      ANY_OPTION_DESCRIPTION = 'ANY_OPTION'
      ANY_OPTION_LONG = '__'
      ANY_OPTION_SHORT = '_'
      SUBCOMMAND_NAME_ARG = :subcommand
      SUBCOMMAND_ARGS_ARG = :subcommand_args

      # @return [Boolean]
      def any_opt
        @any_opt = true
      end

      # @return [Boolean]
      def any_option?
        @any_opt ? true : false
      end

      # @return [EacCli::Definition::BooleanOption]
      def any_options_option
        @any_options_option ||= ::EacCli::Definition::BooleanOption.new(
          ANY_OPTION_SHORT, ANY_OPTION_LONG, ANY_OPTION_DESCRIPTION,
          optional: true, repeat: true, usage: false
        )
      end

      def arg_opt(*args)
        options_set << ::EacCli::Definition::ArgumentOption.from_args(args)
      end

      def bool_opt(*args)
        options_set << ::EacCli::Definition::BooleanOption.from_args(args)
      end

      def options
        options_set.to_a
      end

      def options_argument?
        @options_argument ? true : false
      end

      def options_argument(enable)
        @options_argument = enable

        self
      end

      def pos_arg(name, arg_options = {})
        new_pos_arg = ::EacCli::Definition::PositionalArgument.new(name, arg_options)
        check_positional_blocked(new_pos_arg)
        pos_set << new_pos_arg
      end

      def positional
        pos_set.to_a
      end

      def positional_arguments_blocked_reason(new_pos_arg)
        last = pos_set.last
        return nil unless last
        return 'there are subcommands' if subcommands?
        return 'last argument repeats' if last.repeat?
        return 'new argument is required and last is optional' if
        last.optional? && new_pos_arg.if_present(&:required?)

        nil
      end

      def subcommands
        pos_arg(SUBCOMMAND_NAME_ARG, subcommand: true)
        pos_set << ::EacCli::Definition::PositionalArgument.new(SUBCOMMAND_ARGS_ARG,
                                                                optional: true, repeat: true)
      end

      def subcommands?
        pos_set.any?(&:subcommand?)
      end

      private

      def check_positional_blocked(new_pos_arg)
        positional_arguments_blocked_reason(new_pos_arg).if_present do |v|
          raise ::EacCli::Definition::Error, "Positional arguments are blocked: #{v} " \
                                             "(New argument: #{new_pos_arg})"
        end
      end

      def pos_set
        @pos_set ||= []
      end

      def options_set
        @options_set ||= []
      end
    end
  end
end
