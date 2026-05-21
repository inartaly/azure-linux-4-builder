#!/usr/bin/env bash
set -euo pipefail

# 1. Install necessary tools that the base image is missing
echo "=== Installing build dependencies ==="
dnf install -y git make gcc-c++ binutils glibc-devel

ARCH="${TARGET_ARCH:-x86_64}"

echo "=== Azure Linux 4.0 Builder for $ARCH ==="
mkdir -p /source/work
cd /source/work

# 2. Clone the repo
if [ ! -d "azurelinux" ]; then
    git clone https://github.com/microsoft/azurelinux.git
fi

cd azurelinux

# 3. Build the toolchain first (this takes time but is required)
echo "=== Preparing Build Environment ==="
make package-toolchain

# 4. Build the image
echo "=== Building Azure Linux 4.0 Image ==="
make image CONFIG=toolkit/resources/imageconfigs/full.json ARCH="$ARCH"

# 5. Move the result to the output folder
echo "=== Locating Build Output ==="
find . -name "*.iso" -exec cp {} /source/output/ \;

echo "=== Build Complete for $ARCH ==="
