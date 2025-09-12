# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class FromGemsRegistry < ::EacCli::RunnerWithSet
      def add_from_gems_registry
        ::EacRubyUtils::GemsRegistry.new('RunnerWith').registered.each do |registered_gem|
          add_namespace(registered_gem.registered_module)
        end
      end
    end
  end
end
