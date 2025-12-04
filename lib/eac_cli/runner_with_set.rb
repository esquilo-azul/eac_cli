# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class << self
      def default
        @default ||= ::EacCli::RunnerWithSet::FromGemsRegistry.new
      end
    end

    def add_namespace(namespace)
      namespace = sanitize_namespace(namespace)
      namespace_set << namespace unless namespace_set.include?(namespace)
      self
    end

    def item_to_module(item)
      item.is_a?(::Module) ? item : key_to_module(item)
    end

    def namespaces
      namespace_set.dup
    end

    private

    def namespace_set
      @namespace_set ||= []
    end

    def key_to_module(key)
      namespace_set.lazy
        .map { |namespace| key_to_module_in_namespace(namespace, key) }
        .find(&:present?) ||
        raise("Not module found with key \"#{key}\" (Namespaces: #{namespace_set})")
    end

    def key_to_module_in_namespace(namespace, key)
      leaf_name = key.to_s.camelize.to_sym
      namespace.const_get(leaf_name)
    rescue ::NameError => e
      e.receiver == namespace && e.name == leaf_name ? nil : raise(e)
    end

    def sanitize_namespace(source)
      source.is_a?(::Module) ? source : source.to_s.constantize
    end
  end
end
