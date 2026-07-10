#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COOKBOOK_DIR="${BASE_DIR}/datadog-agent"
DEPENDENCY_DIR="${BASE_DIR}/cookbooks"

echo "Starting Datadog Agent deployment"

if [ ! -d "$COOKBOOK_DIR" ]; then
    echo "Missing datadog-agent cookbook"
    exit 1
fi


echo "Installing Cinc"

if ! command -v cinc-client >/dev/null 2>&1
then
    curl -L https://omnitruck.cinc.sh/install.sh \
    | sudo bash -s -- -P cinc
fi


echo "Installing dependencies"

sudo apt update

sudo apt install -y \
    git \
    ruby \
    build-essential


echo "Installing Berkshelf"

if ! command -v berks >/dev/null 2>&1
then
    sudo cinc gem install berkshelf
fi


mkdir -p "$DEPENDENCY_DIR"


echo "Downloading cookbooks"

cd "$BASE_DIR"

berks vendor "$DEPENDENCY_DIR"


echo "Creating Cinc configuration"


cat > client.rb <<EOF

cookbook_path [
  "${BASE_DIR}",
  "${DEPENDENCY_DIR}"
]

EOF


echo "Running Cinc cookbook"


sudo cinc-client \
    -z \
    -c "${BASE_DIR}/client.rb" \
    -r "recipe[datadog-agent::default]"


echo "Checking Datadog service"

systemctl status datadog-agent --no-pager || true


echo "Deployment completed"
