A new Ubuntu EC2 instance should only need:

git clone <repo>

cd datadog_custom

./deploy_datadog_agent.sh

and everything happens automatically.

Architecture:

                 Fresh Ubuntu EC2

                       |
                       |
                       v

          deploy_datadog_agent.sh

                       |
          +------------+------------+
          |                         |
          v                         v

     Install Cinc              Configure paths

          |
          |
          v

     Run Cookbook

          |
          |
          v

   Datadog Agent Running
Create Script

From:

cd /home/cloud_user/observability-lab/automation/cinc/datadog_custom

Create:

vi deploy_datadog_agent.sh

Add:

#!/bin/bash

set -e

echo "=================================="
echo "Installing Cinc"
echo "=================================="


if ! command -v cinc-client >/dev/null 2>&1
then

curl -L https://omnitruck.cinc.sh/install.sh | \
sudo bash -s -- -P cinc-client

else

echo "Cinc already installed"

fi


echo "=================================="
echo "Running Datadog Cookbook"
echo "=================================="


sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent]'


echo "=================================="
echo "Datadog Agent Status"
echo "=================================="


systemctl status datadog-agent --no-pager

Make executable:

chmod +x deploy_datadog_agent.sh
Test Script

Run:

./deploy_datadog_agent.sh

Expected:

Installing Cinc

Cinc Client, version 19.x

Recipe: datadog-agent::repository

Recipe: datadog-agent::install

Recipe: datadog-agent::service

Recipe: datadog-agent::configure


Datadog Agent Status

Active: active (running)
