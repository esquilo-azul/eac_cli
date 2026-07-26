# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class FromGemsRegistry < ::EacCli::RunnerWithSet
      enable_memoized

      MODULE_SUFFIX = 'RunnerWith'

      protected

      # @return [EacRubyUtils::GemsRegistry]
      memoize def gems_registry
        ::EacRubyUtils::GemsRegistry.new(MODULE_SUFFIX)
      end

      # @return [Enumerable<Object>]
      def namespace_set
        super + gems_registry.registered.map(&:registered_module)
      end
    end
  end
end
