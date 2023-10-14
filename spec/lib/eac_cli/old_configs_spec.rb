# frozen_string_literal: true

require 'eac_cli/old_configs'

RSpec.describe EacCli::OldConfigs do
  describe '#entry_key_to_envvar_name' do
    {
      'a.entry.value' => 'A_ENTRY_VALUE',
      'appli-cation_0.var_one' => 'APPLICATION_0_VAR_ONE'
    }.each do |input, expected_result|
      it { expect(described_class.entry_key_to_envvar_name(input)).to eq(expected_result) }
    end
  end
end
