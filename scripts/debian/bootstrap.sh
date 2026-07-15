#!/usr/bin/env bash

set -euo pipefail

echo "Starting Debian/Ubuntu bootstrap..."

if ! command -v apt >/dev/null 2>&1; then
    echo "This script requires a Debian-based OS"
    exit 1
fi

echo "Updating package repository..."
sudo apt-get update

echo "Installing common dependencies..."

sudo apt-get install -y \
    ca-certificates \
    curl \
    wget \
    git \
    unzip \
    jq \
    gnupg \
    lsb-release \
    software-properties-common \
    build-essential \
    ruby \
    ruby-dev \
    python3 \
    python3-pip

echo "Cleaning package cache..."
sudo apt-get clean

echo "Debian/Ubuntu bootstrap completed successfully."
