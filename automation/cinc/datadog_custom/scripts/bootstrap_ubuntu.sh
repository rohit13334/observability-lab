#!/bin/bash

###############################################################################

# Ubuntu EC2 Bootstrap Script

#

# Purpose:

# Prepare Ubuntu server for Cinc/Chef cookbook execution.

#

# Tested target:

# Ubuntu 22.04 / 24.04

#

###############################################################################

set -euo pipefail

echo "======================================"
echo "Starting Ubuntu Bootstrap"
echo "======================================"

###############################################################################

# Variables

###############################################################################

CINC_VERSION="19"

WORK_DIR="/opt/cinc"

###############################################################################

# System Update

###############################################################################

echo "[1/8] Updating operating system"

apt-get update -y

apt-get upgrade -y

###############################################################################

# Install Base Dependencies

###############################################################################

echo "[2/8] Installing base packages"

apt-get install -y 
curl 
wget 
unzip 
git 
gnupg 
ca-certificates 
apt-transport-https 
software-properties-common 
jq 
vim 
net-tools

###############################################################################

# Install AWS CLI v2

###############################################################################

echo "[3/8] Installing AWS CLI"

if ! command -v aws >/dev/null 2>&1
then

```
cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o awscliv2.zip

unzip -q awscliv2.zip

./aws/install
```

else

```
echo "AWS CLI already installed"
```

fi

aws --version

###############################################################################

# Install Cinc Client

###############################################################################

echo "[4/8] Installing Cinc Client"


echo "[4/8] Installing Cinc Workstation"

if [ ! -d "/opt/cinc-workstation" ]
then

    curl -L https://omnitruck.cinc.sh/install.sh | bash -s -- -P cinc-workstation

else

    echo "Cinc Workstation already installed"

fi


echo "Checking Cinc Workstation"

cinc-workstation --version || true

/opt/cinc-workstation/bin/cinc-client --version



###############################################################################

# Create Automation Directory

###############################################################################

echo "[5/8] Creating automation directories"

mkdir -p ${WORK_DIR}

mkdir -p /home/cloud_user/observability-lab/automation/cinc

###############################################################################

# Configure Git

###############################################################################

echo "[6/8] Installing Git configuration"

git --version

###############################################################################

# Configure Systemd prerequisites

###############################################################################

echo "[7/8] Reloading systemd"

systemctl daemon-reload

###############################################################################

# Validation

###############################################################################

echo "[8/8] Validation"

echo "--------------------------------------"

echo "Hostname:"
hostname

echo "Kernel:"
uname -r

echo "Cinc:"
cinc-client --version

echo "AWS:"
aws --version

echo "======================================"
echo "Bootstrap completed successfully"
echo "======================================"

echo ""
echo "Next steps:"
echo ""
echo "1. Clone repository"
echo "2. Navigate to cookbook directory"
echo "3. Run:"
echo ""
echo "sudo cinc-client -z -c client.rb -r 'recipe[datadog-agent::default]'"
echo ""

