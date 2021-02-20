# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/patches'

::EacCli::RunnerWithSet.default.add_namespace(::EacCli::RunnerWith)
