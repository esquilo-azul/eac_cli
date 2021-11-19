# frozen_string_literal: true

require 'eac_ruby_utils/enum'
require 'eac_ruby_utils/core_ext'

module EacCli
  # A [EacRubyUtils::Enum] which each value is associated with one console color.
  class Enum < ::EacRubyUtils::Enum
    # Foreground color used in [to_bg_label]
    TO_BG_LABEL_FG_COLOR = :light_white

    attr_reader :color

    def initialize(key, color)
      super(key)
      @color = color
    end

    delegate :to_s, to: :key

    # @return [String]
    def to_label
      to_fg_label
    end

    # @return [String]
    def to_fg_label
      to_fg_bg_label(color)
    end

    # @return [String]
    def to_bg_label
      to_fg_bg_label(TO_BG_LABEL_FG_COLOR, color)
    end

    private

    # @return [String]
    def to_fg_bg_label(fg_color, bg_color = nil)
      colors = { color: fg_color }
      bg_color.if_present { |v| colors[:background] = v }
      ::ColorizedString[to_s].colorize(colors)
    end
  end
end
