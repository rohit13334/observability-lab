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
