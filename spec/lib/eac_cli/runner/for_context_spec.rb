# frozen_string_literal: true

require 'eac_cli/runner'

::RSpec.describe EacCli::Runner, '#for_context' do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:parent_runner_class) do
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ParentRunnerClass'
      end

      for_context :method_for_context

      def run; end

      def method_for_context; end

      def method_not_for_context; end
    end
  end

  let(:child_runner_class1) do # rubocop:disable RSpec/IndexedLet
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ChildRunnerClass1'
      end

      def run
        method_for_context
        runner_context.call(:method_for_context)
        runner_context.call(:method_not_for_context)
      end
    end
  end

  let(:child_runner_class2) do # rubocop:disable RSpec/IndexedLet
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ChildRunnerClass2'
      end

      def run
        method_not_for_context
      end
    end
  end

  let(:parent_runner) { parent_runner_class.create }
  let(:context_args) { [{ argv: [], parent: parent_runner }] }
  let(:child_runner) { child_runner_class.create(*context_args) }

  it { expect(parent_runner.for_context?(:method_for_context)).to be(true) }
  it { expect(parent_runner.for_context?(:method_not_for_context)).to be(false) }

  context 'when method is for context' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:child_runner_class) { child_runner_class1 }

    it do
      expect { child_runner.run }.not_to raise_error
    end
  end

  context 'when method is not for context' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:child_runner_class) { child_runner_class2 }

    it do
      expect { child_runner.run }.to raise_error(::NameError)
    end
  end
end
