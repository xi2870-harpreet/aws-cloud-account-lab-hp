#!/bin/bash
# Equivalent of the legacy `track_scripts/setup-cloud-client`.

set -uo pipefail

# ---------------------------------------------------------------------------
# Guard the positional credential reference.
#
# sandbox.hcl reads credentials as `resource.aws_account.example.user.0.*`.
# Instruqt documents name-keyed access (`user.student`) but the CLI rejects it -
# `user` is a plain list, so the reference is positional and would silently
# repoint if a user block were added above `student`.
#
# INSTRUQT_RESOLVED_USER carries whatever `user.0` actually resolved to, so a
# reordering fails here, loudly, instead of handing out the wrong credentials.
# ---------------------------------------------------------------------------
INTENDED_USER="student"

if [ -n "${INSTRUQT_RESOLVED_USER:-}" ] && [ "$INSTRUQT_RESOLVED_USER" != "$INTENDED_USER" ]; then
  echo "FATAL: sandbox.hcl 'user.0' resolves to '${INSTRUQT_RESOLVED_USER}', expected '${INTENDED_USER}'." >&2
  echo "       A user block was probably added above 'student'; the credentials" >&2
  echo "       injected into the containers are not the ones this lab intends." >&2
  exit 1
fi

# Region comes from AWS_DEFAULT_REGION on the container; the default VPC is
# what `aws ec2 run-instances` needs in order to launch without a subnet id.
aws configure set region "${AWS_DEFAULT_REGION:-eu-west-2}" --profile default

# Idempotent: fails harmlessly if a default VPC already exists.
aws ec2 create-default-vpc || true

aws sts get-caller-identity || true
