# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class FromGemsRegistry < ::EacCli::RunnerWithSet
      protected

      # @return [Enumerable<Object>]
      def namespace_set
        super + ::EacRubyUtils::GemsRegistry.new('RunnerWith').registered.map(&:registered_module)
      end
    end
  end
end
