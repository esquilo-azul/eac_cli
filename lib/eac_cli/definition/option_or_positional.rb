# frozen_string_literal: true

module EacCli
  class Definition
    # @abstract
    class OptionOrPositional
      acts_as_abstract :build_value, :default_value, :identifier, :options
      enable_listable

      OPTION_LIST = %i[optional repeat required].freeze

      # @return [Boolean]
      def optional?
        !required?
      end

      # @raise [EacCli::Definition::Error]
      def raise(*args)
        ::Kernel.raise ::EacCli::Definition::Error, *args
      end

      # @return [Boolean]
      def repeat?
        options[:repeat] ? true : false
      end

      # @return [Boolean]
      def required?
        return true if options.key?(:required) && options.fetch(:required)
        return false if options.key?(:optional) && options.fetch(:optional)

        self.class.const_get('DEFAULT_REQUIRED')
      end

      # @return [String]
      def to_s
        "#{self.class.name.demodulize}[#{identifier}]"
      end
    end
  end
end
