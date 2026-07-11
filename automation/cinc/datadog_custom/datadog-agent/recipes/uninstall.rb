#
# Cookbook:: datadog-agent
# Recipe:: uninstall
#

service 'datadog-agent' do
  action [:stop, :disable]
  ignore_failure true
end


package node['datadog']['package_name'] do
  action :remove
end


if node['datadog']['remove_config']
directory '/etc/datadog-agent' do
  action :delete
  recursive true
end
