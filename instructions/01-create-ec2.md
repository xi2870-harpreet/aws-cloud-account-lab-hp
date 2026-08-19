# 👋 Introduction

Every cloud starts from a VM.

This lab gives you a **sandboxed AWS account** wired straight into the lab
environment. Your credentials are already exported in the **Cloud CLI** tab, so
the AWS CLI is ready to go — no `aws configure` needed.

Open the **AWS Console** tab at any time to see the username, password and
access keys for the account.

## Create the instance

First, look up an AMI to boot from. Hardcoding an image id is a trap: ids differ
per region and images get deregistered over time. AWS publishes the current ones
as **public SSM parameters**, so ask for the latest Ubuntu 22.04 image instead:

```
AMI_ID=$(aws ssm get-parameters   --names /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id   --query 'Parameters[0].Value' --output text)

echo $AMI_ID
```

Now launch a `t2.nano` instance from it:

```
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.nano
```

Confirm it came up:

```
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType]' --output table
```

<instruqt-task id="create_ec2"></instruqt-task>

## About the environment

The **Ubuntu** tab is a container running Ubuntu 24.04 with the AWS CLI
installed and the same account credentials in its environment — handy when you
want a general-purpose workspace alongside the cloud client.

> The sandbox account is capped to `t2.nano` sized instances by its IAM policy.
> Adjust the policy in `sandbox.hcl` to fit your own workloads.
