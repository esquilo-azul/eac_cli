# frozen_string_literal: true

require 'csv'
require 'eac_ruby_utils'
require 'eac_cli/runner_with/output_item/base_formatter'

module EacCli
  module RunnerWith
    module OutputItem
      class CsvFormatter < ::EacCli::RunnerWith::OutputItem::BaseFormatter
        COLUMNS = %w[key value].freeze

        # @return [String]
        def to_output
          ::CSV.generate do |csv|
            csv << COLUMNS
            item_hash.each { |k, v| csv << [k, v] }
          end
        end
      end
    end
  end
end
