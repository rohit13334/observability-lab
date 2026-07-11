#
# Cookbook:: datadog-agent
# Attributes:: default
#

# Datadog Configuration
default['datadog']['api_key'] = '9464cf3c84cc1eb5ac8970a06c8d0be8'
default['datadog']['site'] = 'datadoghq.com'
default['datadog']['env'] = 'development'

# Package
default['datadog']['package_name'] = 'datadog-agent'
default['datadog']['agent_version'] = nil

# Service
default['datadog']['service_name'] = 'datadog-agent'
default['datadog']['process_agent_enabled'] = true
# Features
default['datadog']['logs_enabled'] = true
default['datadog']['apm_enabled'] = true
default['datadog']['process_collection'] = true

# Repository
default['datadog']['repo_url'] = 'https://apt.datadoghq.com'

# Uninstall settings
#

default['datadog']['remove_config'] = true
