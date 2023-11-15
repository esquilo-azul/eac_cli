# frozen_string_literal: true

require 'eac_cli/runner_with/output_list'

RSpec.describe EacCli::RunnerWith::OutputList do
  let(:runner) do
    the_module = described_class
    Class.new do
      include the_module

      def run
        run_output
      end

      def list_columns
        %w[id name]
      end

      def list_rows
        [[1, 'João'], [2, 'Maria']].map { |v| Struct.new(:id, :name).new(*v) }
      end
    end
  end

  let(:instance) { runner.create(argv: runner_argv) }

  {
    'csv' => <<~OUTPUT,
      id,name
      1,João
      2,Maria
    OUTPUT
    'tty' => <<~OUTPUT,
      ┌──┬─────┐
      │id│name │
      │1 │João │
      ├──┼─────┤
      │2 │Maria│
      └──┴─────┘
    OUTPUT
    'yaml' => <<~OUTPUT
      ---
      - id: '1'
        name: João
      - id: '2'
        name: Maria
    OUTPUT
  }.each do |format, expected_output|
    context "with --format=#{format}" do
      let(:runner_argv) { ['--format', format] }

      it do
        expect { instance.run }.to output(expected_output).to_stdout_from_any_process
      end
    end
  end
end
