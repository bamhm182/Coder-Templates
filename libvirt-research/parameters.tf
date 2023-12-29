data "coder_parameter" "baseline_image" {
  name         = "baseline_image"
  display_name = "Baseline image"
  description  = "Which Baseline would you like to use?"
  default      = "nixos-browser"
  type         = "string"
  mutable      = false

  option {
    name  = "Browser"
    value = "nixos-browser"
  }
  option {
    name  = "OSINT"
    value = "nixos-osint"
  }
}

data "coder_parameter" "router_image" {
  name         = "router_image"
  display_name = "Router"
  description  = "Which Router would you like to use?"
  default      = "router"
  type         = "string"
  mutable      = true

  option {
    name = "Standard"
    value = "router"
  }
  option {
    name = "Tor"
    value = "router-tor"
  }
}

data "coder_parameter" "vlan" {
  name = "vlan"
  display_name = "Network"
  description = "Which network would you like?"
  default = "vpn-0"
  type = "string"
  mutable = true

  option {
    name  = "VPN1"
    value = "vpn-0"
  }
  option {
    name  = "VPN2"
    value = "vpn-1"
  }
  option {
    name  = "VPN3"
    value = "vpn-2"
  }
  option {
    name  = "VPN4"
    value = "vpn-3"
  }
  option {
    name  = "VPN5"
    value = "vpn-4"
  }
}
