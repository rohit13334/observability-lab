#!/usr/bin/env bash

set -euo pipefail

PACKAGES=(
    vim
    tree
    net-tools
    dnsutils
)

echo "Installing additional Debian packages..."

sudo apt-get update

sudo apt-get install -y "${PACKAGES[@]}"

echo "Additional packages installed."
