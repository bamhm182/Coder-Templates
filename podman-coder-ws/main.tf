terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "bamhm182/docker"
    }
  }
}

provider "docker" {}


data "coder_provisioner" "me" {}

data "coder_workspace" "me" {}

data "coder_parameter" "template" {
  name         = "template"
  display_name = "Template"
  description  = "Which template would you like to use?"
  default      = "basic"
  type         = "string"
  mutable      = false
  option {
    name  = "Basic"
    value = "basic"
    icon  = "/icon/code.svg"
  }
  option {
    name  = "LaTeX"
    value = "latex"
    icon  = "/emojis/1f4d6.png"
  }
}

resource "coder_agent" "main" {
  arch                   = data.coder_provisioner.me.arch
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e
    /usr/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
  EOT

  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
  }
}

resource "coder_script" "personalize" {
  agent_id     = coder_agent.main.id
  script       = <<-EOT
    install -dm 0700 ~/.ssh
    ssh-keyscan -p 2222 git.lab.bytepen.com >> ~/.ssh/known_hosts
    git clone "ssh://git@git.lab.bytepen.com:2222/${data.coder_workspace.me.owner}/dotfiles.git" ~/.config/coderv2/dotfiles 2>&1 | tee -a ~/.dotfiles.log
    bash ~/.config/coderv2/dotfiles/install.sh 2>&1 | tee -a ~/.dotfiles.log
    EOT
  display_name = "Dotfiles"
  icon         = "/icon/dotfiles.svg"
  run_on_start = true
}

module "code-server" {
  source = "registry.coder.com/modules/code-server/coder"
  version = "1.0.0"
  agent_id = coder_agent.main.id
  extensions = (
    data.coder_parameter.template.value == "latex" ?
    [ "james-yu.latex-workshop", "anwar.papyrus-pdf", "streetsidesoftware.code-spell-checker" ] :
      data.coder_parameter.template.value == "base" ?
      [ "dracula-theme.theme-dracula" ] :
      [ ]
  )
  folder = "/home/${data.coder_workspace.me.owner}"
  settings = {
    "workbench.colorTheme" = "Dark (Visual Studio)"
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  lifecycle {
    ignore_changes = all
  }
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.id}"
  build {
    context = "./templates/${data.coder_parameter.template.value}"
    build_args = {
      USER = data.coder_workspace.me.owner
    }
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "build/*") : filesha1(f)]))
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  hostname = data.coder_workspace.me.name
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/home/${data.coder_workspace.me.owner}"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

