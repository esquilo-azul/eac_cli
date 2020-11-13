# frozen_string_literal: true

require 'eac_cli/docopt/runner_extension'

RSpec.describe ::EacCli::Docopt::RunnerExtension do
  let(:stub_runner) do
    r = Class.new(::EacRubyUtils::Console::DocoptRunner) do
      def run; end
    end
    r.include ::EacCli::Runner
    r.runner_definition do
      desc 'A stub runner.'
      arg_opt '-o', '--opt1', 'A argument option'
      pos_arg 'pos1'
    end
    r
  end

  let(:instance) { stub_runner.new(argv: %w[-o aaa bbb]) }

  before { instance.run }

  it { expect(instance.options.fetch('--opt1')).to eq('aaa') }
  it { expect(instance.options.fetch('<pos1>')).to eq('bbb') }
end
