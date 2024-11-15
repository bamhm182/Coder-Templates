terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "1.0.4"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "coder" {}
provider "libvirt" {}
