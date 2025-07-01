# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  module Runner
    module ContextResponders
      class Base
        acts_as_abstract :call, :callable?
        common_constructor :context, :method_name do
          self.method_name = method_name.to_sym
        end
        delegate :parent, :runner, to: :context

        def if_callable # rubocop:disable Naming/PredicateMethod
          return false unless callable?

          yield(self)
          true
        end
      end
    end
  end
end
