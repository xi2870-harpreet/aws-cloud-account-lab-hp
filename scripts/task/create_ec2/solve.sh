#!/bin/bash
# Legacy equivalent: solve-cloud-client
#
# The AMI id is resolved at runtime from a public SSM parameter rather than
# hardcoded. A literal id is both region-specific and perishable - images get
# deregistered, and the lab breaks silently when that happens.
#
# Ubuntu (not Amazon Linux 2023) because this lab pins t2.nano: t2 is a
# Xen-based family, and AL2023 only supports Nitro instances.
set -euo pipefail

SSM_PARAM="/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"

AMI_ID=$(aws ssm get-parameters \
  --names "$SSM_PARAM" \
  --query 'Parameters[0].Value' \
  --output text)

if [ -z "$AMI_ID" ] || [ "$AMI_ID" = "None" ]; then
  echo "Could not resolve an AMI from $SSM_PARAM" >&2
  exit 1
fi

echo "Using AMI $AMI_ID"
aws ec2 run-instances --image-id "$AMI_ID" --instance-type t2.nano
