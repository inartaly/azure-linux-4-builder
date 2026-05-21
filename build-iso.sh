#!/usr/bin/env bash
set -euo pipefail

ARCH="${TARGET_ARCH:-x86_64}"

echo "=== Azure Linux 4.0 Builder for $ARCH ==="

# Ensure we are in the workspace
mkdir -p /source/work
cd /source/work

# Clone if not present
if [ ! -d "azurelinux" ]; then
    git clone https://github.com/microsoft/azurelinux.git
fi

cd azurelinux

echo "=== Preparing Build Environment ==="
# The official way to prepare the environment
make package-toolchain

echo "=== Building Azure Linux 4.0 Image ==="
# Using the standard make command to build the full image
# This avoids path issues with scripts
make image CONFIG=toolkit/resources/imageconfigs/full.json ARCH="$ARCH"

echo "=== Locating Build Output ==="
# Azure Linux usually outputs here
find . -name "*.iso" -exec cp {} /source/output/ \;

echo "=== Build Complete for $ARCH ==="
