# frozen_string_literal: true

require 'yaml'

module EacCli
  module RunnerWith
    module OutputList
      class YamlFormatter < ::EacCli::RunnerWith::OutputList::BaseFormatter
        # @return [Hash<String, String>]
        def build_row(row)
          build_columns.inject({}) { |a, e| a.merge(e => build_value(row, e).to_s) }
        end

        # @return [String]
        def to_output
          ::YAML.dump(build_rows)
        end
      end
    end
  end
end
