# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Definition
    class BaseOption
      require_sub __FILE__

      class << self
        def from_args(args)
          p = ::EacCli::Definition::BaseOption::InitializeArgsParser.new(args)
          new(p.short, p.long, p.description, p.options)
        end
      end

      DEFAULT_REQUIRED = false

      enable_listable
      enable_abstract_methods :build_value, :default_value
      lists.add_symbol :option, :optional, :usage, :repeat, :required
      common_constructor :short, :long, :description, :options, default: [{}] do
        raise 'Nor short neither long selector was set' if short.blank? && long.blank?

        self.options = ::EacCli::Definition::BaseOption.lists.option.hash_keys_validate!(
          options.symbolize_keys
        )
      end

      def identifier
        [long, short].each do |v|
          v.to_s.if_present { |vv| return vv.variableize.to_sym }
        end

        raise 'No short or long option to build identifier'
      end

      def repeat?
        options[OPTION_REPEAT]
      end

      def required?
        return true if options.key?(:required) && options.fetch(:required)
        return false if options.key?(:optional) && options.fetch(:optional)

        DEFAULT_REQUIRED
      end

      def to_s
        "#{self.class.name.demodulize}[#{identifier}]"
      end

      def show_on_usage?
        options[:usage]
      end
    end
  end
end
