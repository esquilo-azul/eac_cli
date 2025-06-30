# frozen_string_literal: true

require 'csv'

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
