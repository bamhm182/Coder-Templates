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
    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "coder" {}
provider "guacamole" {}
provider "libvirt" {}

