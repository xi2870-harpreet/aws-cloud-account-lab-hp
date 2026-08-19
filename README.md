# AWS Cloud Account Copy (Containers)

An Instruqt **Lab** (HCL / Instruqt 2.0) port of the legacy track
`instruqt-support/aws-cloud-account-copy-hp`, with the Ubuntu **VM replaced by a
container**.

## Layout

| File | Purpose |
| --- | --- |
| `main.hcl` | Lab metadata, chapters, pages |
| `sandbox.hcl` | Network, AWS account, containers, setup execs |
| `tabs.hcl` | Terminals, cloud credentials, virtual browser |
| `layouts.hcl` | Two-column layouts (instructions on the right) |
| `tasks.hcl` | Interactive tasks + validation wiring |
| `instructions/` | Page markdown |
| `scripts/` | `exec` setup scripts and task check/solve scripts |

## What changed from the legacy track

| Legacy (`config.yml` / `track.yml`) | This lab |
| --- | --- |
| `virtualmachines: ubuntu` (ubuntu-2404-noble, 8 GB, 2 cpu) | `resource "container" "workstation"` — `ubuntu:24.04`, 2 GB, 2 cpu |
| `containers: cloud-client` (`gcr.io/instruqt/cloud-client`, port 80) | `resource "container" "cloud_client"` — `amazon/aws-cli:2.17.0` |
| "AWS Console" service tab on cloud-client:80 | `resource "cloud_credentials" "aws"` (native) |
| `virtualbrowsers: vbt` | `resource "virtual_browser" "aws_console"` |
| `aws_accounts: example` | `resource "aws_account" "example"` with a `user "student"` block |
| `track_scripts/setup-cloud-client` | `resource "exec" "cloud_client_setup"` |
| `track_scripts/setup-ubuntu` (fully commented out) | `resource "exec" "workstation_setup"` — installs AWS CLI; heavier tools kept commented |
| `01-*/check-cloud-client`, `solve-cloud-client` | `scripts/task/create_ec2/{check,solve}.sh` |
| `02-*/check-cloud-client`, `solve-cloud-client` | `scripts/task/delete_ec2/{check,solve}.sh` |
| `fail-message '...'` in check scripts | `failure_message` on the `check` block; scripts just exit non-zero |
| `jq` parsing of `describe-instances` | AWS CLI `--query` (JMESPath) — no extra dependency |
| `"Test"` tab on `cloud-client:8501` | dropped — port 8501 was never exposed in `config.yml` |

## Validate

```bash
instruqt lab validate
```
