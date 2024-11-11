terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "1.0.4"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "1.2.1"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "coder" {}
provider "libvirt" {}
