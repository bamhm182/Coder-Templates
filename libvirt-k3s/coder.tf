data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

locals {
  agents = [
    coder_agent.Kubernetes
  ]
}

resource "coder_agent" "Kubernetes" {
  os           = "linux"
  arch         = "amd64"

  display_apps {
    vscode          = false
    vscode_insiders = false
    web_terminal    = false
    ssh_helper      = false
  }

  metadata {
    key          = "cpu"
    display_name = "CPU Usage"
    interval     = 5
    timeout      = 5
    script       = "coder stat cpu"
  }

  metadata {
    key          = "memory"
    display_name = "Memory Usage"
    interval     = 5
    timeout      = 5
    script       = "coder stat mem"
  }

  metadata {
    key          = "disk"
    display_name = "Home Usage"
    interval     = 600 # every 10 minutes
    timeout      = 30  # df can take a while on large filesystems
    script       = "coder stat disk --path /home/user"
  }
}
