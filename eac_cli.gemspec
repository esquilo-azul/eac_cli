# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_cli/version'

Gem::Specification.new do |s|
  s.name        = 'eac_cli'
  s.version     = EacCli::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Utilities to build CLI applications with Ruby.'

  s.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH)
              .reject { |f| ['.', '..'].include?(File.basename(f)) }

  s.required_ruby_version = '>= 3.2' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'clipboard', '~> 2.0'
  s.add_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  s.add_dependency 'eac_config', '~> 0.15', '>= 0.15.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.134'
  s.add_dependency 'tty-table', '~> 0.12'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.15'
end
