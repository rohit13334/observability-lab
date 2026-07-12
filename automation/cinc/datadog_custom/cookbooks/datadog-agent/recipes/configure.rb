#
# Cookbook:: datadog-agent
# Recipe:: configure
#

template '/etc/datadog-agent/datadog.yaml' do
  source 'datadog.yaml.erb'
  owner 'dd-agent'
  group 'dd-agent'
  mode '0640'
  notifies :restart, 'service[datadog-agent]', :delayed
end
