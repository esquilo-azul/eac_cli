# frozen_string_literal: true

require 'eac_cli/runner_with/help'
require 'eac_ruby_utils'

RSpec.describe EacCli::RunnerWith::Help do
  let(:runner) do
    the_module = described_class
    Class.new do
      include the_module

      runner_definition do
        desc 'A stub runner.'
        pos_arg :a_argument
      end

      def run
        puts 'Runner run'
      end
    end
  end

  [
    ['--help'],
    ['trash-pos-arg-before', '--help', 'trash-pos-arg-after', '--any-option', '-XYZ',
     'other-trash-arg']
  ].each do |runner_argv|
    context "when runner ARGV is #{runner_argv}" do
      let(:instance) { runner.create(argv: runner_argv) }
      let(:expected_output_source) do
        <<~OUTPUT
          A stub runner.

          Usage:
            __PROGRAM__ [options] <a_argument>
            __PROGRAM__ --help

          Options:
            -h --help    Show help.
        OUTPUT
      end
      let(:expected_output) do
        expected_output_source.gsub('__PROGRAM__', instance.program_name)
      end

      it 'show help text' do
        expect { instance.run_run }.to output(expected_output).to_stdout_from_any_process
      end
    end
  end
end
