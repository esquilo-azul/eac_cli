# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Speaker
    module Options
      common_concern do
        enable_listable
        lists.add_symbol :option, :out_out, :err_out, :in_in, :parent, :err_line_prefix
      end

      def err_out
        option(OPTION_ERR_OUT, ::EacCli::Speaker::STDERR)
      end

      def out_out
        option(OPTION_OUT_OUT, ::EacCli::Speaker::STDOUT)
      end

      def in_in
        option(OPTION_IN_IN, ::EacCli::Speaker::STDIN)
      end

      def err_line_prefix
        option(OPTION_ERR_LINE_PREFIX, '')
      end

      def parent
        options[OPTION_PARENT]
      end

      def option(key, default)
        options[key] || parent.if_present(default) { |v| v.send(__METHOD__) }
      end
    end
  end
end
