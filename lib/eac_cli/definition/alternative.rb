# frozen_string_literal: true

require 'eac_cli/definition/argument_option'
require 'eac_cli/definition/boolean_option'
require 'eac_cli/definition/positional_argument'

module EacCli
  class Definition
    class Alternative
      SUBCOMMAND_NAME_ARG = :subcommand
      SUBCOMMAND_ARGS_ARG = :subcommand_args

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

      def positional_arguments_blocked?(new_pos_arg)
        last = pos_set.last
        return false unless last
        return true if subcommands?
        return true if last.repeat?
        return true if last.optional? && new_pos_arg.if_present(&:required?)

        false
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
        raise 'Positional arguments are blocked' if positional_arguments_blocked?(new_pos_arg)
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
