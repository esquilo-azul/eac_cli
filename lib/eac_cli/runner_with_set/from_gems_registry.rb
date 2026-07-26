# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class FromGemsRegistry < ::EacCli::RunnerWithSet
      MODULE_SUFFIX = 'RunnerWith'

      protected

      # @return [Enumerable<Object>]
      def namespace_set
        super + ::EacRubyUtils::GemsRegistry.new(MODULE_SUFFIX).registered.map(&:registered_module)
      end
    end
  end
end
