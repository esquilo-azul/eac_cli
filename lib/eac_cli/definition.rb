# frozen_string_literal: true

require 'eac_cli/definition/argument_option'
require 'eac_cli/definition/boolean_option'
require 'eac_cli/definition/positional_argument'
require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    require_sub __FILE__

    MAIN_ALTERNATIVE_KEY = :main
    SUBCOMMAND_NAME_ARG = 'subcommand'
    SUBCOMMAND_ARGS_ARG = 'subcommand_args'

    attr_accessor :description

    def initialize
      self.description = '-- NO DESCRIPTION SET --'
      alternatives_set[MAIN_ALTERNATIVE_KEY] = main_alternative
    end

    def alt(&block)
      r = ::EacCli::Definition::Alternative.new
      r.instance_eval(&block)
      alternatives_set[new_alternative_key] = r
      r
    end

    def alternatives
      alternatives_set.values
    end

    def alternative(key)
      alternatives_set.fetch(key)
    end

    def desc(description)
      self.description = description
    end

    def help_formatter
      @help_formatter ||= ::EacCli::Definition::HelpFormatter.new(self)
    end

    def main_alternative
      @main_alternative ||= begin
        r = ::EacCli::Definition::Alternative.new
        r.options_argument(true)
        r
      end
    end

    def options_arg(options_argument)
      self.options_argument = options_argument
    end

    def options_argument
      main_alternative.options_argument?
    end

    def options_argument=(enable)
      main_alternative.options_argument(enable)
    end

    delegate :arg_opt, :bool_opt, :options, :pos_arg,
             :positional, :subcommands, to: :main_alternative

    def subcommands?
      alternatives.any?(&:subcommands?)
    end

    def options_first(enable = true)
      @options_first = enable
    end

    def options_first?
      @options_first ? true : false
    end

    private

    def alternatives_set
      @alternatives_set ||= ::ActiveSupport::HashWithIndifferentAccess.new
    end

    def new_alternative_key
      @last_key ||= 0
      loop do
        @last_key += 1
        break @last_key unless alternatives_set.key?(@last_key)
      end
    end

    def pos_set
      @pos_set ||= []
    end
  end
end
