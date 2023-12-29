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
    linode = {
      source = "linode/linode"
      version = "2.12.0"
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
provider "linode" {}
