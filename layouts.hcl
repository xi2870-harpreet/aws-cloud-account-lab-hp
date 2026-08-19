# ---------------------------------------------------------------------------
# Default layout - mirrors the legacy `default_layout: AssignmentRight` with a
# 33% sidebar: work surface on the left, instructions on the right.
# ---------------------------------------------------------------------------
resource "layout" "default" {
  column {
    width = "67"

    tab "cloud_cli" {
      title  = "Cloud CLI"
      target = resource.terminal.cloud_cli
      active = true
    }

    tab "aws_credentials" {
      title  = "AWS Console"
      target = resource.cloud_credentials.aws
    }

    tab "aws_console" {
      title  = "AWS Console (Browser)"
      target = resource.external_website.aws_console
    }

    tab "workstation" {
      title  = "Ubuntu"
      target = resource.terminal.workstation
    }
  }

  column {
    width = "33"

    instructions {
      title  = "Instructions"
      active = true
    }
  }
}

# ---------------------------------------------------------------------------
# Console-only layout - the legacy second challenge exposed just the AWS
# Console tab. The virtual browser is included here so the console steps in
# that chapter are actually followable.
# ---------------------------------------------------------------------------
resource "layout" "console_only" {
  column {
    width = "67"

    tab "aws_credentials" {
      title  = "AWS Console"
      target = resource.cloud_credentials.aws
      active = true
    }

    tab "aws_console" {
      title  = "AWS Console (Browser)"
      target = resource.external_website.aws_console
    }

    # The legacy challenge exposed only the console tab, which left no way to
    # finish the chapter if the console was unavailable. The instructions offer
    # a CLI alternative, so give it somewhere to run.
    tab "cloud_cli" {
      title  = "Cloud CLI"
      target = resource.terminal.cloud_cli
    }
  }

  column {
    width = "33"

    instructions {
      title  = "Instructions"
      active = true
    }
  }
}
