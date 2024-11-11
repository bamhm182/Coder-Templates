data "coder_parameter" "droplet_image" {
  name         = "droplet_image"
  display_name = "Droplet image"
  description  = "Which Droplet image would you like to use?"
  default      = "ubuntu-22-04-x64"
  type         = "string"
  mutable      = true
  option {
    name  = "AlmaLinux 9"
    value = "almalinux-9-x64"
    icon  = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/almalinux.svg"
  }
  option {
    name  = "AlmaLinux 8"
    value = "almalinux-8-x64"
    icon  = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/almalinux.svg"
  }
  option {
    name  = "CentOS Stream 9"
    value = "centos-stream-9-x64"
    icon  = "/icon/centos.svg"
  }
  option {
    name  = "CentOS Stream 8"
    value = "centos-stream-8-x64"
    icon  = "/icon/centos.svg"
  }
  option {
    name  = "CentOS 7"
    value = "centos-7-x64"
    icon  = "/icon/centos.svg"
  }
  option {
    name  = "Debian 12"
    value = "debian-12-x64"
    icon  = "/icon/debian.svg"
  }
  option {
    name  = "Debian 11"
    value = "debian-11-x64"
    icon  = "/icon/debian.svg"
  }
  option {
    name  = "Debian 10"
    value = "debian-10-x64"
    icon  = "/icon/debian.svg"
  }
  option {
    name  = "Fedora 39"
    value = "fedora-39-x64"
    icon  = "/icon/fedora.svg"
  }
  option {
    name  = "Fedora 38"
    value = "fedora-38-x64"
    icon  = "/icon/fedora.svg"
  }
  option {
    name  = "Rocky Linux 9"
    value = "rockylinux-9-x64"
    icon  = "/icon/rockylinux.svg"
  }
  option {
    name  = "Rocky Linux 8"
    value = "rockylinux-8-x64"
    icon  = "/icon/rockylinux.svg"
  }
  option {
    name  = "Ubuntu 23.10"
    value = "ubuntu-23-10-x64"
    icon  = "/icon/ubuntu.svg"
  }
  option {
    name  = "Ubuntu 23.04"
    value = "ubuntu-23-04-x64"
    icon  = "/icon/ubuntu.svg"
  }
  option {
    name  = "Ubuntu 22.04 (LTS)"
    value = "ubuntu-22-04-x64"
    icon  = "/icon/ubuntu.svg"
  }
  option {
    name  = "Ubuntu 20.04 (LTS)"
    value = "ubuntu-20-04-x64"
    icon  = "/icon/ubuntu.svg"
  }
}

data "coder_parameter" "droplet_size" {
  name         = "droplet_size"
  display_name = "Droplet size"
  description  = "Which Droplet configuration would you like to use?"
  default      = "s-1vcpu-512mb-10gb"
  type         = "string"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name = "1 vCPU, 512 MB RAM ($0.006/hr, $4/mo)"
    value = "s-1vcpu-512mb-10gb"
  }
  option {
    name  = "1 vCPU, 1 GB RAM ($0.009/hr, $6/mo)"
    value = "s-1vcpu-1gb"
  }
  option {
    name  = "1 vCPU, 2 GB RAM ($0.018/hr, $12/mo)"
    value = "s-1vcpu-2gb"
  }
  option {
    name  = "2 vCPU, 2 GB RAM ($0.027/hr, $18/mo)"
    value = "s-2vcpu-2gb"
  }
  option {
    name  = "2 vCPU, 4 GB RAM ($0.036/hr, $24/mo)"
    value = "s-2vcpu-4gb"
  }
  option {
    name  = "4 vCPU, 8 GB RAM ($0.071/hr, $48/mo)"
    value = "s-4vcpu-8gb"
  }
  option {
    name = "8 vCPU, 16 GB RAM ($0.143/hr, $96/mo)"
    value = "s-8vcpu-16gb"
  }
}

data "coder_parameter" "home_volume_size" {
  name         = "home_volume_size"
  display_name = "Home volume size"
  description  = "How large would you like your home volume to be (in GB)?"
  type         = "number"
  default      = "20"
  mutable      = false
  validation {
    min = 1
    max = 100
  }
}

data "coder_parameter" "region" {
  name         = "region"
  display_name = "Region"
  description  = "This is the region where your workspace will be created. (*: 1vCPU, 512 MB RAM Droplet Size Unsupported)"
  icon         = "/emojis/1f30e.png"
  type         = "string"
  default      = "ams3"
  mutable      = false
  # These regions do not support volumes, which are used to persist data while decreasing cost:
  #   - nyc1, sfo1, ams2
  option {
    name  = "* Canada (Toronto)"
    value = "tor1"
    icon  = "/emojis/1f1e8-1f1e6.png"
  }
  option {
    name  = "Germany (Frankfurt)"
    value = "fra1"
    icon  = "/emojis/1f1e9-1f1ea.png"
  }
  option {
    name  = "* India (Bangalore)"
    value = "blr1"
    icon  = "/emojis/1f1ee-1f1f3.png"
  }
  option {
    name  = "Netherlands (Amsterdam)"
    value = "ams3"
    icon  = "/emojis/1f1f3-1f1f1.png"
  }
  option {
    name  = "Singapore"
    value = "sgp1"
    icon  = "/emojis/1f1f8-1f1ec.png"
  }
  option {
    name  = "* United Kingdom (London)"
    value = "lon1"
    icon  = "/emojis/1f1ec-1f1e7.png"
  }
  option {
    name  = "* United States (California - 2)"
    value = "sfo2"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "United States (California - 3)"
    value = "sfo3"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "United States (New York - 1)"
    value = "nyc1"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name  = "* United States (New York - 3)"
    value = "nyc3"
    icon  = "/emojis/1f1fa-1f1f8.png"
  }
}
