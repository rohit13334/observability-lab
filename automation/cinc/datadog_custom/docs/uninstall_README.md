How it works
Normal uninstall

Run:

sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::uninstall]'

Result:

service stopped
service disabled
datadog-agent package removed

/etc/datadog-agent remains
Purge uninstall

Override the attribute at runtime:

sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::uninstall]' \
--json-attributes '{"datadog":{"remove_config":true}}'

Result:

service stopped
service disabled
datadog-agent package removed
/etc/datadog-agent deleted
Updated lifecycle
                 datadog-agent cookbook


                         |
             +-----------+-----------+
             |                       |
             v                       v


        default.rb             uninstall.rb


             |                       |
             |                       |
             v                       v


        Deployment             Removal


             |                       |
             v                       v


       Install Agent          Stop Service


             |                       |
             v                       v


       Configure YAML         Remove Package


             |                       |
             v                       v


       Start Service          Optional Purge


                                     |
                                     v

                           Delete Configuration
