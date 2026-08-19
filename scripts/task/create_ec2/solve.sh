#!/bin/bash
# Legacy equivalent: solve-cloud-client
# NOTE: this AMI id is pinned to eu-west-2. Refresh it if the region changes
# or the image is deregistered.
aws ec2 run-instances \
  --image-id ami-01685d240b8fbbfeb \
  --instance-type t2.nano
