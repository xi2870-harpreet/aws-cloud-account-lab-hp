# 🚀 Let's start

You just created your EC2 virtual machine — let's remove it.

## Log in to the AWS console

1. Open the **AWS Console** tab to read your credentials.
2. Switch to the **AWS Console (Browser)** tab and sign in with them.
3. Navigate to **Services → EC2 → Instances**.

## 🏁 Finish

Terminate the instance you created.

Select the instance, then choose **Instance state → Terminate instance**.

<instruqt-task id="delete_ec2"></instruqt-task>

> Prefer the CLI? `aws ec2 terminate-instances --instance-ids <id>` does the
> same thing.
