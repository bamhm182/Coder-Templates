terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    guacamole = {
      source = "bamhm182/guacamole"
    }
  }
}

provider "coder" {}

provider "digitalocean" {
  # Env:
  #   DIGITALOCEAN_TOKEN: Digital Ocean API Token
}

provider "guacamole" {
  # Env:
  #   GUACAMOLE_URL: Guacamole URL
  #   GUACAMOLE_USERNAME: Guacamole Username
  #   GUACAMOLE_PASSWORD: Guacamole Password
}
