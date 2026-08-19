# 👋 Introduction

Every cloud starts from a VM.

This lab gives you a **sandboxed AWS account** wired straight into the lab
environment. Your credentials are already exported in the **Cloud CLI** tab, so
the AWS CLI is ready to go — no `aws configure` needed.

Open the **AWS Console** tab at any time to see the username, password and
access keys for the account.

## Create the instance

Use the **Cloud CLI** terminal to launch a `t2.nano` EC2 instance:

```
aws ec2 run-instances --image-id ami-01685d240b8fbbfeb --instance-type t2.nano
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
