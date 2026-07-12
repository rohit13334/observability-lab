#
# Cookbook:: datadog-agent
# Attributes:: default
#

# Datadog Configuration
default['datadog']['api_key'] = nil
default['datadog']['site'] = 'datadoghq.com'
default['datadog']['env'] = 'development'

# AWS Secrets Manager configuration

default['datadog']['secret_name'] = 'datadog/api_key'
default['datadog']['aws_region'] = 'us-east-1'

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
