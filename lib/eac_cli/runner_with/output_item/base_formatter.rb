# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/acts_as_abstract'

module EacCli
  module RunnerWith
    module OutputItem
      class BaseFormatter
        acts_as_abstract :to_output
        common_constructor :item_hash
      end
    end
  end
end
