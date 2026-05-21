#!/usr/bin/env bash
set -euo pipefail

ARCH="${TARGET_ARCH:-x86_64}"

echo "=== Azure Linux 4.0 Builder for $ARCH ==="
echo "=== Installing Core Prerequisites ==="

dnf -y update
dnf -y install \
  git \
  curl \
  python3 \
  python3-pip \
  mock \
  rpm-build \
  createrepo_c \
  golang \
  kiwi-cli \
  make \
  gcc \
  tar \
  xz \
  unzip

groupadd -f mock || true
usermod -a -G mock root

echo "=== Preparing Azure Linux 4.0 Workspace ==="
mkdir -p /source/work
cd /source/work

if [ ! -d "azurelinux" ]; then
    git clone https://github.com/microsoft/azurelinux.git
fi

cd azurelinux

echo "=== Building Azure Linux 4.0 Image for $ARCH ==="
# Updated path to the new script location
bash imagebuilder.sh \
  --config toolkit/resources/imageconfigs/full.json \
  --arch "$ARCH" \
  --output-dir /source/output

echo "=== Build Complete for $ARCH ==="
