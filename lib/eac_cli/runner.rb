# frozen_string_literal: true

module EacCli
  module Runner
    require_sub __FILE__
    extend ::ActiveSupport::Concern

    class << self
      def alias_runner_class_methods(klass, from_suffix, to_suffix)
        %i[create run].each do |method|
          alias_class_method(klass, build_method_name(method, from_suffix),
                             build_method_name(method, to_suffix))
        end
      end

      def runner?(object)
        object.is_a?(::Class) && object.included_modules.include?(::EacCli::Runner)
      end

      private

      def alias_class_method(klass, from, to)
        sklass = klass.singleton_class
        return unless sklass.method_defined?(from)

        sklass.send(:alias_method, to, from)
      end

      def build_method_name(name, suffix)
        ss = suffix.if_present('') { |s| "#{s}_" }
        "#{ss}#{name}"
      end
    end

    the_module = self
    included do
      the_module.alias_runner_class_methods(self, '', 'original')

      extend AfterClassMethods
      include InstanceMethods
      include ::EacCli::Runner::ForContext
      include ActiveSupport::Callbacks

      define_callbacks :run
    end
  end
end
