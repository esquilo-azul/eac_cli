# frozen_string_literal: true

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
