# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_cli/version'

Gem::Specification.new do |s|
  s.name        = 'eac_cli'
  s.version     = EacCli::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Utilities to build CLI applications with Ruby.'

  s.files = Dir['{lib}/**/*', 'Gemfile']

  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  s.add_dependency 'eac_config', '~> 0.15'
  s.add_dependency 'eac_ruby_utils', '~> 0.128', '>= 0.128.4'
  s.add_dependency 'tty-table', '~> 0.12'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12'
end
