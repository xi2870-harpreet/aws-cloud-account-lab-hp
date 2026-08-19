#!/bin/bash
# Legacy equivalent: fail while any instance is still running (state 16) or
# pending (state 0). Filtering server-side is both clearer and not limited to
# the first reservation the way the original `[0]` indexing was.

active=$(aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=pending,running" \
  --query 'length(Reservations[].Instances[])' \
  --output text 2>/dev/null)

case "$active" in
  ''|None|null) active=0 ;;
esac

if [ "$active" -gt 0 ]; then
  exit 1
fi

exit 0
