# frozen_string_literal: true

require 'yaml'

module EacCli
  module RunnerWith
    module OutputItem
      class YamlFormatter < ::EacCli::RunnerWith::OutputItem::BaseFormatter
        # @return [String]
        def to_output
          ::YAML.dump(item_hash.deep_stringify_keys)
        end
      end
    end
  end
end
