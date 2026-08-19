# ---------------------------------------------------------------------------
# Network - foundation for all container communication
# ---------------------------------------------------------------------------
resource "network" "main" {
  subnet = "10.0.200.0/24"
}

# ---------------------------------------------------------------------------
# Sandboxed AWS account
#
# Mirrors the legacy `aws_accounts: - name: example` block. The legacy track
# granted AdministratorAccess + AmazonBedrockFullAccess to both the user and
# the admin role; in HCL that becomes one `user` block per identity.
# ---------------------------------------------------------------------------
resource "aws_account" "example" {
  regions = ["eu-west-2"]

  services = [
    "ec2",
    "s3",
    "iam",
    "bedrock",
    # Required to resolve the AMI id from a public SSM parameter at runtime
    # instead of hardcoding one.
    "ssm",
  ]

  tags = {
    Environment = "Lab"
    Purpose     = "AWS Cloud Account Copy"
  }

  # NOTE: credentials are referenced elsewhere as `user.0`, positionally.
  # Name-keyed access (`user.student`) is documented by Instruqt but rejected by
  # the CLI - `user` is a plain list. Adding a user block ABOVE this one would
  # silently repoint every credential in this file, so keep `student` first.
  # `exec.cloud_client_setup` asserts this at startup.
  user "student" {
    managed_policies = [
      "arn:aws:iam::aws:policy/AdministratorAccess",
      "arn:aws:iam::aws:policy/AmazonBedrockFullAccess",
    ]
  }
}

# ---------------------------------------------------------------------------
# Cloud CLI container - replaces the legacy `gcr.io/instruqt/cloud-client`
# container. Credentials are injected as environment variables; the console
# credential page that image served on port 80 is now the native
# `cloud_credentials` tab (see tabs.hcl).
# ---------------------------------------------------------------------------
resource "container" "cloud_client" {
  image {
    name = "amazon/aws-cli:2.17.0"
  }

  # The upstream image sets `aws` as its entrypoint; override it so the
  # terminal tab gets an interactive shell instead.
  entrypoint = ["/bin/bash"]
  command    = ["-c", "sleep infinity"]

  environment = {
    AWS_ACCESS_KEY_ID     = resource.aws_account.example.user.0.access_key_id
    AWS_SECRET_ACCESS_KEY = resource.aws_account.example.user.0.secret_access_key
    AWS_DEFAULT_REGION    = "eu-west-2"
    AWS_REGION            = "eu-west-2"
  }

  resources {
    cpu    = 1000
    memory = 1024
  }

  network {
    id = resource.network.main.meta.id
  }
}

# ---------------------------------------------------------------------------
# Workstation container - REPLACES the legacy `virtualmachines: - name: ubuntu`
# VM (ubuntu-2404-noble, 8192MB, 2 cpus).
#
# The legacy VM existed to host CLI tooling (eksctl / kubectl / terraform); the
# setup script that installed it was fully commented out upstream. A container
# covers the same ground at a fraction of the boot time and cost.
# ---------------------------------------------------------------------------
resource "container" "workstation" {
  image {
    name = "ubuntu:24.04"
  }

  entrypoint = ["/bin/bash"]
  command    = ["-c", "sleep infinity"]

  environment = {
    AWS_ACCESS_KEY_ID     = resource.aws_account.example.user.0.access_key_id
    AWS_SECRET_ACCESS_KEY = resource.aws_account.example.user.0.secret_access_key
    AWS_DEFAULT_REGION    = "eu-west-2"
    AWS_REGION            = "eu-west-2"
    DEBIAN_FRONTEND       = "noninteractive"
  }

  resources {
    cpu    = 2000
    memory = 2048
  }

  network {
    id = resource.network.main.meta.id
  }
}

# ---------------------------------------------------------------------------
# Setup - equivalent of the legacy `track_scripts/setup-cloud-client`
# ---------------------------------------------------------------------------
resource "exec" "cloud_client_setup" {
  target = resource.container.cloud_client
  script = "scripts/exec/cloud_client_setup/script.sh"

  # Lets the script verify that `user.0` still resolves to the intended user.
  environment = {
    INSTRUQT_RESOLVED_USER = resource.aws_account.example.user.0.username
  }

  timeout = "300s"
}

# ---------------------------------------------------------------------------
# Setup - equivalent of the legacy `track_scripts/setup-ubuntu`
# ---------------------------------------------------------------------------
resource "exec" "workstation_setup" {
  target  = resource.container.workstation
  script  = "scripts/exec/workstation_setup/script.sh"
  timeout = "600s"
}
