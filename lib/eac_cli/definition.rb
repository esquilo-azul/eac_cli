# frozen_string_literal: true

require 'eac_cli/definition/argument_option'
require 'eac_cli/definition/boolean_option'
require 'eac_cli/definition/positional_argument'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    require_sub __FILE__

    SUBCOMMAND_NAME_ARG = 'subcommand'
    SUBCOMMAND_ARGS_ARG = 'subcommand_args'

    attr_accessor :description
    attr_accessor :options_argument

    def initialize
      self.description = '-- NO DESCRIPTION SET --'
      self.options_argument = true
    end

    def alt(&block)
      r = ::EacCli::Definition.new
      r.instance_eval(&block)
      alternatives << r
      r
    end

    def alternatives
      @alternatives ||= []
    end

    def arg_opt(short, long, description, option_options = {})
      options << ::EacCli::Definition::ArgumentOption.new(
        short, long, description, option_options
      )
    end

    def bool_opt(short, long, description, option_options = {})
      options << ::EacCli::Definition::BooleanOption.new(short, long, description, option_options)
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
      raise 'Positional arguments are blocked' if positional_arguments_blocked?

      pos_set << ::EacCli::Definition::PositionalArgument.new(name, arg_options)
    end

    def positional
      pos_set.to_a
    end

    def positional_arguments_blocked?
      pos_set.any? { |e| e.optional? || e.repeat? }
    end

    def subcommands
      pos_arg(SUBCOMMAND_NAME_ARG, subcommand: true)
      pos_set << ::EacCli::Definition::PositionalArgument.new(SUBCOMMAND_ARGS_ARG,
                                                              optional: true, repeat: true)
    end

    def subcommands?
      pos_set.any?(&:subcommand?)
    end

    def options_first(enable = true)
      @options_first = enable
    end

    def options_first?
      @options_first ? true : false
    end

    private

    def pos_set
      @pos_set ||= []
    end
  end
end
