terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    guacamole = {
      source = "bamhm182/guacamole"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
    }
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    random = {
      source = "hashicorp/random"
    }
    ssh = {
      source = "loafoe/ssh"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "coder" {}
provider "guacamole" {}
provider "libvirt" {}
