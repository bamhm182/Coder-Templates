data "coder_parameter" "baseline_image" {
  name         = "baseline_image"
  display_name = "Baseline image"
  description  = "Which Baseline would you like to use?"
  default      = "nixos-ctf"
  type         = "string"
  mutable      = false

  option {
    name  = "Base"
    value = "nixos-base"
  }
  option {
    name  = "Browser"
    value = "nixos-browser"
  }
  option {
    name  = "CTF"
    value = "nixos-ctf"
  }
  option {
    name = "Obsidian"
    value = "nixos-obsidian"
  }
  option {
    name  = "OSINT"
    value = "nixos-osint"
  }
  option {
    name  = "Synack LP+"
    value = "nixos-synacklpp"
  }
}

data "coder_parameter" "vlan" {
  name = "vlan"
  display_name = "Network"
  description = "Which network would you like?"
  default = "clear"
  type = "string"
  mutable = true

  option {
    name  = "Clear"
    value = "clear"
  }
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
  option {
    name  = "Experiment"
    value = "experiment"
  }
}

data "coder_parameter" "cpu_count" {
  name         = "cpu_count"
  display_name = "CPU Count"
  description  = "How many CPU's would you like?"
  default      = "2"
  type         = "string"
  icon         = "/icon/memory.svg"
  mutable      = true

  option {
    name  = "1 CPU"
    value = "1"
  }
  option {
    name  = "2 CPUs"
    value = "2"
  }
  option {
    name  = "4 CPUs"
    value = "4"
  }
  option {
    name  = "8 CPUs"
    value = "8"
  }
}

data "coder_parameter" "ram_amount" {
  name         = "ram_amount"
  display_name = "RAM Amount"
  description  = "How much RAM would you like?"
  default      = "8192"
  type         = "string"
  mutable      = true

  option {
    name = "1 GB"
    value = "1024"
  }
  option {
    name = "2 GB"
    value = "2048"
  }
  option {
    name = "4 GB"
    value = "4096"
  }
  option {
    name = "8 GB"
    value = "8192"
  }
  option {
    name = "16 GB"
    value = "16384"
  }
  option {
    name = "32 GB"
    value = "32768"
  }
}
