# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_cli/runner_with/subcommands'

RSpec.describe ::EacCli::RunnerWith::Subcommands do
  let(:parent_runner) do
    the_module = described_class
    the_child = child_runner
    Class.new do
      include ::EacCli::Runner
      include the_module
      const_set('ChildCmd', the_child)

      runner_definition do
        desc 'A stub root runner.'
        arg_opt '-r', '--root-var', 'A root variable.'
        subcommands
      end

      delegate :root_var, to: :parsed
    end
  end

  let(:child_runner) do
    ::Class.new do
      include ::EacCli::Runner

      runner_definition do
        bool_opt '-c', '--child-opt', 'A boolean option.'
        pos_arg :child_var
      end

      def run; end
    end
  end

  let(:instance) { parent_runner.create(argv: parent_argv) }

  context 'when subcommand is supplied' do
    let(:parent_argv) { %w[--root-var 123 child-cmd --child-opt 456] }

    it { expect(instance.parsed.root_var).to eq('123') }
    it { expect(instance.parsed.subcommand).to eq('child-cmd') }
    it { expect(instance.parsed.subcommand_args).to eq(%w[--child-opt 456]) }
    it { expect(instance.subcommand_runner.parsed.child_opt).to eq(true) }
    it { expect(instance.subcommand_runner.parsed.child_var).to eq('456') }
  end

  context 'when subcommand is not supplied' do
    let(:instance) { parent_runner.create(%w[456]) }

    it do
      expect { instance.run }.to raise_error(::EacCli::Parser::Error)
    end
  end
end
