# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_cli/runner_with/output_item/base_formatter'
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
