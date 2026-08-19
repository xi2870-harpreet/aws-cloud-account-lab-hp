#!/bin/bash
# Equivalent of the legacy `track_scripts/setup-cloud-client`.
# Region comes from AWS_DEFAULT_REGION on the container; the default VPC is
# what `aws ec2 run-instances` needs in order to launch without a subnet id.

aws configure set region "${AWS_DEFAULT_REGION:-eu-west-2}" --profile default

# Idempotent: fails harmlessly if a default VPC already exists.
aws ec2 create-default-vpc || true

aws sts get-caller-identity || true
