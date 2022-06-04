# frozen_string_literal: true

module EacCli
  class RunnerWithSet
    class << self
      def default
        @default ||= new
      end
    end

    def add_namespace(namespace)
      namespace = sanitize_namespace(namespace)
      raise "\"#{namespace}\" already was included" if namespace_set.include?(namespace)

      namespace_set << namespace
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
      @namespace_set ||= ::Array.new
    end

    def key_to_module(key)
      namespace_set.lazy
        .map { |namespace| key_to_module_in_namespace(namespace, key) }
        .find(&:present?) ||
        raise("Not module found with key \"#{key}\" (Namespaces: #{namespace_set})")
    end

    def key_to_module_in_namespace(namespace, key)
      namespace.const_get(key.to_s.camelize)
    rescue ::NameError
      nil
    end

    def sanitize_namespace(source)
      source.is_a?(::Module) ? source : source.to_s.constantize
    end
  end
end
