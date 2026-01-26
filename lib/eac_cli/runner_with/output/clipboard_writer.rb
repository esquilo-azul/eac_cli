# frozen_string_literal: true

require 'clipboard'

module EacCli
  module RunnerWith
    module Output
      class ClipboardWriter
        def write(content)
          ::Clipboard.copy(content)
        end
      end
    end
  end
end
