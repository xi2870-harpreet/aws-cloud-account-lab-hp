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
# Virtual browser - legacy `virtualbrowsers: - name: vbt`
# ---------------------------------------------------------------------------
resource "virtual_browser" "aws_console" {
  url = "https://signin.aws.amazon.com/console"
}
