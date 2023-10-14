# frozen_string_literal: true

require 'eac_cli/runner_with/confirmation'

RSpec.describe EacCli::RunnerWith::Confirmation do
  let(:runner) do
    the_module = described_class
    Class.new do
      include the_module

      runner_definition do
        desc 'A stub runner.'
      end

      def run
        if confirm?
          Kernel.puts 'Accepted'
        else
          Kernel.puts 'Denied'
        end
      end
    end
  end

  let(:instance) { runner.create(argv: runner_argv) }

  context 'without --no option' do
    let(:runner_argv) { %w[--no] }

    it do
      expect { instance.run }.to output("Denied\n").to_stdout_from_any_process
    end
  end

  context 'without --yes option' do
    let(:runner_argv) { %w[--yes] }

    it do
      expect { instance.run }.to output("Accepted\n").to_stdout_from_any_process
    end
  end
end
