# frozen_string_literal: true

module EacCli
  class DocoptRunner
    # Provides the method context which search and call a method in self and ancestor objects.
    module Context
      def context(method)
        current = self
        while current
          return current.send(method) if current.respond_to?(method)

          current = current.respond_to?(:parent) ? current.parent : nil
        end
        raise "Context method \"#{method}\" not found for #{self.class}"
      end
    end
  end
end
