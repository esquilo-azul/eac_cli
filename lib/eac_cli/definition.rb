# frozen_string_literal: true

module EacCli
  class Definition
    require_sub __FILE__

    MAIN_ALTERNATIVE_KEY = :main
    SUBCOMMAND_NAME_ARG = 'subcommand'
    SUBCOMMAND_ARGS_ARG = 'subcommand_args'

    # @return [String, nil]
    attr_accessor :description

    def initialize
      self.description = '-- NO DESCRIPTION SET --'
      alternatives_set[MAIN_ALTERNATIVE_KEY] = main_alternative
    end

    # @return [EacCli::Definition::Alternative]
    def alt(key = nil, &block)
      key ||= new_alternative_key
      raise(::EacCli::Definition::Error, "A alternative with key=\"#{key}\" already exists") if
        key.present? && alternatives_set.key?(key)

      r = ::EacCli::Definition::Alternative.new
      r.instance_eval(&block)
      alternatives_set[key] = r
      r
    end

    # @return [Enumerable<EacCli::Definition::Alternative>]
    def alternatives
      alternatives_set.values
    end

    # @return [EacCli::Definition::Alternative]
    # @raise [KeyError] If there is not a alternative with provided key.
    def alternative(key)
      alternatives_set.fetch(key)
    end

    # Same as {#description=}.
    def desc(description)
      self.description = description
    end

    # @return [EacCli::Definition::Alternative]
    def main_alternative
      @main_alternative ||= begin
        r = ::EacCli::Definition::Alternative.new
        r.options_argument(true)
        r
      end
    end

    # Same as {#options_argument=}.
    # @param options_argument [Boolean]
    def options_arg(options_argument)
      self.options_argument = options_argument
    end

    # @return [Boolean]
    def options_argument # rubocop:disable Naming/PredicateMethod
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

    def options_first(enable = true) # rubocop:disable Style/OptionalBooleanParameter
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
