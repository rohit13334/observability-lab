#
# Cookbook:: datadog-agent
# Recipe:: service
#
# This is a core Chef concept: recipe inclusion is cumulative and behaves like a call chain.

service 'datadog-agent' do
  action [:enable, :start]
end

include_recipe 'datadog-agent::configure'
