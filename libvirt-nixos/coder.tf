data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  os           = "linux"
  arch         = "amd64"
  count        = data.coder_workspace.me.start_count

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

resource "coder_app" "guacamole_rdp" {
  agent_id     = coder_agent.main[0].id
  count        = length(guacamole_connection_rdp.main)
  display_name = "Desktop"
  slug         = "guacamolerdp"
  icon         = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/guacamole.svg"
  external     = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_rdp.main[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "coder_app" "guacamole_ssh" {
  agent_id     = coder_agent.main[0].id
  count        = length(guacamole_connection_ssh.main)
  display_name = "Terminal"
  slug         = "guacamolessh"
  icon         = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/guacamole.svg"
  external     = true
  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.main[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}
