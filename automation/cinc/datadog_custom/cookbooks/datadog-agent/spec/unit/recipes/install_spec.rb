require 'spec_helper'

describe 'datadog-agent::install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '22.04'
    ).converge(described_recipe)
  end

  it 'installs the Datadog Agent package' do
    expect(chef_run).to install_package('datadog-agent')
  end
end
