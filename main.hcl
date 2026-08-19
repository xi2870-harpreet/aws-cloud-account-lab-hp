# ---------------------------------------------------------------------------
# Pages
# ---------------------------------------------------------------------------
resource "page" "create_ec2" {
  title = "Create an AWS EC2 instance"
  file  = "instructions/01-create-ec2.md"

  activities = {
    create_ec2 = resource.task.create_ec2
  }
}

resource "page" "delete_ec2" {
  title = "AWS EC2 instance deletion"
  file  = "instructions/02-delete-ec2.md"

  activities = {
    delete_ec2 = resource.task.delete_ec2
  }
}

# ---------------------------------------------------------------------------
# Lab
# ---------------------------------------------------------------------------
resource "lab" "main" {
  title = "AWS Cloud Account Copy (Containers)"

  description = <<-EOT
    Learn how to use a sandboxed AWS account in your Instruqt lab.

    **This lab demonstrates how to:**
      - Link an AWS cloud account to your sandbox
      - Use a container-based cloud client instead of a VM
      - Use the AWS CLI and console from the lab environment
      - Limit usage of the cloud account using IAM and SCP policies

    The default settings of this lab only expect t2.nano sized EC2 instances.
    Adjust the IAM policy to fit your own use case and application size.
  EOT

  settings {
    timelimit {
      duration   = "2h"
      show_timer = true
    }

    controls {
      show_stop = true
    }
  }

  layout = resource.layout.default

  content {
    chapter "create" {
      title = "Create an AWS EC2 instance"

      page "create_ec2" {
        reference = resource.page.create_ec2
      }
    }

    chapter "delete" {
      title  = "AWS EC2 instance deletion"
      layout = resource.layout.console_only

      page "delete_ec2" {
        reference = resource.page.delete_ec2
      }
    }
  }
}
