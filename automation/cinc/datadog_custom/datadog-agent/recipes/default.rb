#
# Cookbook:: datadog-agent
# Recipe:: default
#
# Copyright:: 2026, The Authors, All Rights Reserved.
#

#
# Cookbook:: datadog-agent
# Recipe:: default
#
include_recipe 'datadog-agent::secrets'
include_recipe 'datadog-agent::repository'

include_recipe 'datadog-agent::install'

include_recipe 'datadog-agent::service'

include_recipe 'datadog-agent::configure'
