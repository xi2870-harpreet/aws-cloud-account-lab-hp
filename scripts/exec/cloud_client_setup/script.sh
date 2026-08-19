#!/bin/bash
# Equivalent of the legacy `track_scripts/setup-cloud-client`.
#
# Never exit non-zero: an exec failure aborts sandbox creation for the whole
# lab, so problems here are reported, not fatal.

set -uo pipefail

# ---------------------------------------------------------------------------
# Report the positional credential reference.
#
# sandbox.hcl reads credentials as `resource.aws_account.example.user.0.*`.
# Instruqt documents name-keyed access (`user.student`) but the CLI rejects it -
# `user` is a plain list, so the reference is positional and would silently
# repoint if a user block were added above `student`.
#
# INSTRUQT_RESOLVED_USER carries whatever `user.0` resolved to. It is the
# generated IAM username, NOT the HCL block label, so it is logged for
# traceability rather than asserted against the label.
# ---------------------------------------------------------------------------
echo "sandbox.hcl 'user.0' -> IAM user: '${INSTRUQT_RESOLVED_USER:-<unset>}'"

# Region comes from AWS_DEFAULT_REGION on the container; the default VPC is
# what `aws ec2 run-instances` needs in order to launch without a subnet id.
aws configure set region "${AWS_DEFAULT_REGION:-eu-west-2}" --profile default || true

# Idempotent: fails harmlessly if a default VPC already exists.
aws ec2 create-default-vpc || true

# Confirms which identity the injected credentials actually belong to.
aws sts get-caller-identity || true

exit 0
