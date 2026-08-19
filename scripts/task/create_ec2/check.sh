#!/bin/bash
# Legacy equivalent:
#   instanceCount=$(aws ec2 describe-instances | jq -r '.Reservations[0].Instances | length')
#   [[ $instanceCount -lt 1 ]] && fail-message '...'
#
# Uses --query instead of jq so the check has no dependency beyond the AWS CLI.

count=$(aws ec2 describe-instances \
  --query 'length(Reservations[].Instances[])' \
  --output text 2>/dev/null)

# Guard against empty / "None" output from the CLI.
case "$count" in
  ''|None|null) count=0 ;;
esac

if [ "$count" -lt 1 ]; then
  exit 1
fi

exit 0
