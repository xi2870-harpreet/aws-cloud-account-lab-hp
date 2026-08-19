#!/bin/bash
# Legacy equivalent: solve-cloud-client
ids=$(aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text)

if [ -z "$ids" ]; then
  echo "No instances to terminate."
  exit 0
fi

for id in $ids; do
  echo "Terminating $id"
  aws ec2 terminate-instances --instance-ids "$id"
done
