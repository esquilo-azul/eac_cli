# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    # @abstract
    class Option
      require_sub __FILE__

      class << self
        # @param args [Enumerable<String>]
        # @return [EacCli::Definition::Option]
        def from_args(args)
          p = ::EacCli::Definition::Option::InitializeArgsParser.new(args)
          new(p.short, p.long, p.description, p.options)
        end
      end

      DEFAULT_REQUIRED = false

      enable_listable
      enable_abstract_methods :build_value
      lists.add_symbol :option, :default, :optional, :usage, :repeat, :required

      # @!method initialize(short, long, description, options = {})
      # @param short [String]
      # @param long [String]
      # @param description [String]
      # @param options [Hash<Symbol, Object>]
      # @raise [RuntimeError]
      common_constructor :short, :long, :description, :options, default: [{}] do
        validate
        self.options = ::EacCli::Definition::Option.lists.option.hash_keys_validate!(
          options.symbolize_keys
        )
      end

      # @return [Object]
      def default_value
        default_value? ? options[OPTION_DEFAULT] : default_default_value
      end

      # @return [Boolean]
      def default_value?
        options.key?(OPTION_DEFAULT)
      end

      # @return [Symbol]
      # @raise [EacCli::Definition::Error] If no short or long option is provided.
      def identifier
        [long, short].each do |v|
          v.to_s.if_present { |vv| return vv.variableize.to_sym }
        end

        raise(::EacCli::Definition::Error, 'No short or long option to build identifier')
      end

      # @return [Boolean]
      def repeat?
        options[OPTION_REPEAT]
      end

      # @return [Boolean]
      def required?
        return true if options.key?(:required) && options.fetch(:required)
        return false if options.key?(:optional) && options.fetch(:optional)

        DEFAULT_REQUIRED
      end

      # @return [String]
      def to_s
        "#{self.class.name.demodulize}[#{identifier}]"
      end

      # @return [Boolean]
      def show_on_usage?
        options[:usage]
      end

      private

      # @return [void]
      # @raise [RuntimeError]
      def validate
        raise 'Nor short neither long selector was set' if short.blank? && long.blank?
      end
    end
  end
end
