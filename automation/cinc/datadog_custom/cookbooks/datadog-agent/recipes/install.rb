#
# Cookbook:: datadog-agent
# Recipe:: install
#

# Chef doesn't know that it needs the repository first. Hence need to add the following on the top

# This attribute is already defined in the attributes
#
package node['datadog']['package_name'] do
  action :install
end
