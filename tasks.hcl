# ---------------------------------------------------------------------------
# Legacy challenge 01 - `check-cloud-client` / `solve-cloud-client`
# ---------------------------------------------------------------------------
resource "task" "create_ec2" {
  description     = "Create an EC2 instance with the AWS CLI"
  success_message = "Nice - your EC2 instance is up."

  config {
    target  = resource.container.cloud_client
    timeout = "120s"
  }

  condition "instance_exists" {
    description = "Launch a t2.nano EC2 instance"

    check {
      script          = "scripts/task/create_ec2/check.sh"
      failure_message = "Please create an instance to proceed"
    }

    solve {
      script = "scripts/task/create_ec2/solve.sh"
    }
  }
}

# ---------------------------------------------------------------------------
# Legacy challenge 02 - `check-cloud-client` / `solve-cloud-client`
# ---------------------------------------------------------------------------
resource "task" "delete_ec2" {
  description     = "Terminate the EC2 instance you created"
  success_message = "Instance terminated - the account is clean again."

  config {
    target  = resource.container.cloud_client
    timeout = "120s"
  }

  condition "instance_terminated" {
    description = "Terminate the running EC2 instance"

    check {
      script          = "scripts/task/delete_ec2/check.sh"
      failure_message = "Please terminate instance to proceed"
    }

    solve {
      script = "scripts/task/delete_ec2/solve.sh"
    }
  }
}
