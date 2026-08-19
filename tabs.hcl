# ---------------------------------------------------------------------------
# Terminal on the cloud CLI container - legacy "Cloud CLI" tab
# ---------------------------------------------------------------------------
resource "terminal" "cloud_cli" {
  target = resource.container.cloud_client
  shell  = "/bin/bash"
}

# ---------------------------------------------------------------------------
# Terminal on the workstation container - legacy "Ubuntu" tab, which pointed
# at the VM. Same tab, container-backed.
# ---------------------------------------------------------------------------
resource "terminal" "workstation" {
  target = resource.container.workstation
  shell  = "/bin/bash"
}

# ---------------------------------------------------------------------------
# AWS credentials - legacy "AWS Console" tab, which was the cloud-client
# container's credential page proxied on port 80. This is the native
# replacement.
# ---------------------------------------------------------------------------
resource "cloud_credentials" "aws" {
  aws_account {
    target = resource.aws_account.example
    users  = ["student"]
  }
}

# ---------------------------------------------------------------------------
# AWS console - legacy `virtualbrowsers: - name: vbt`
#
# NOT a `virtual_browser`: that resource validates fine but is silently dropped
# when used as a layout tab target, so the tab never appears in a running lab.
# `external_website` is the supported target (see the layout reference's tab
# target table) and documents cloud consoles as a use case.
#
# open_in_new_window because the AWS sign-in page sets frame-ancestors and
# refuses to render inside the lab's iframe.
# ---------------------------------------------------------------------------
resource "external_website" "aws_console" {
  url                = "https://signin.aws.amazon.com/console"
  open_in_new_window = true
}
