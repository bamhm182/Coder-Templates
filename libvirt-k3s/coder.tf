data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  os           = "linux"
  arch         = "amd64"
  count        = data.coder_workspace.me.start_count == 0 ? 0 : var.node_count

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
