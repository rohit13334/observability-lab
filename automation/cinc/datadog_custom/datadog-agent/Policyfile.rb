# Policyfile.rb - Describe how you want Cinc Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Cinc does.
name 'datadog-agent'

# Where to find external cookbooks:
default_source :supermarket

# run_list: cinc-client will run these recipes in the order specified.
run_list 'datadog-agent::default'

# Specify a custom source for a single cookbook:
cookbook 'datadog-agent', path: '.'
