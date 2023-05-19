# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Runner
    module ContextResponders
      class Base
        acts_as_abstract :call, :callable?
        common_constructor :context, :method_name do
          self.method_name = method_name.to_sym
        end
        delegate :parent, :runner, to: :context

        def if_callable
          return false unless callable?

          yield(self)
          true
        end
      end
    end
  end
end
