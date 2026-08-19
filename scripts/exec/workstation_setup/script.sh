#!/bin/bash
# Equivalent of the legacy `track_scripts/setup-ubuntu`.
#
# In the legacy track this script was entirely commented out, so the Ubuntu VM
# booted bare. Here we install a small, fast baseline so the terminal is
# actually usable against the sandboxed AWS account. The heavier tooling the
# original script reached for is preserved below, still commented, ready to be
# switched on.
#
# Never fail the lab on a transient mirror hiccup.
set +e

echo "Installing baseline tooling..."
apt-get update -y
apt-get install -y --no-install-recommends curl unzip jq less ca-certificates

### Install AWS CLI v2
echo "Installing AWS CLI..."
ARCH="$(uname -m)"
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip \
  && unzip -q /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install \
  && rm -rf /tmp/aws /tmp/awscliv2.zip
aws --version

# ---------------------------------------------------------------------------
# Optional extras, carried over from the legacy setup-ubuntu script.
# Uncomment what your lab needs.
# ---------------------------------------------------------------------------

### Install eksctl
# ARCH=amd64
# PLATFORM="$(uname -s)_$ARCH"
# curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"
# tar -xzf "eksctl_${PLATFORM}.tar.gz" -C /tmp
# install -m 0755 /tmp/eksctl /usr/local/bin/eksctl
# rm -f "eksctl_${PLATFORM}.tar.gz"
# eksctl version

### Install kubectl (latest stable)
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl && mv kubectl /usr/local/bin/
# kubectl version --client

### Install Terraform
# curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" > /etc/apt/sources.list.d/hashicorp.list
# apt-get update -y && apt-get install -y terraform
# terraform version

exit 0
