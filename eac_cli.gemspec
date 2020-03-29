# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_cli/version'

Gem::Specification.new do |s|
  s.name        = 'eac_cli'
  s.version     = ::EacCli::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Utilities to build CLI applications with Ruby.'

  s.files = Dir['{lib}/**/*', 'Gemfile']
end
