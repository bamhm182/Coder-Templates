data "coder_parameter" "linode_type" {
  name = "linode_type"
  display_name = "Linode Type"
  description = "Which Linode Type would you like to use?"
  default = "g6-nanode-1"
  type = "string"
  mutable = false
  option {
    name = "1 CPU, 1GB RAM ($0.0075/hr, $5/mo)"
    value = "g6-nanode-1"
  }
  option {
    name = "1 CPU, 2 GB RAM ($0.018/hr, $12/mo)"
    value = "g6-standard-1"
  }
  option {
    name = "2 CPU, 4 GB RAM ($0.036/hr, $24/mo)"
    value = "g6-standard-2"
  }
  option {
    name = "4 CPU, 8 GB RAM ($0.072/hr, $48/mo)"
    value = "g6-standard-4"
  }
}

data "coder_parameter" "linode_region" {
  name = "linode_region"
  display_name = "Linode Region"
  description = "Which Linode Region would you like to use? (* Increased Pricing)"
  default = "us-iad"
  type = "string"
  mutable = false
  option {
    name = "Australia (Sydney)"
    value = "ap-southeast"
    icon = "/emojis/1f1e6-1f1fa.png"
  }
  option {
    name = "* Brazil (San Paulo)"
    value = "br-gru"
    icon = "/emojis/1f1e7-1f1f7.png"
  }
  option {
    name = "Canada (Toronto)"
    value = "ca-central"
    icon = "/emojis/1f1e6-1f1fa.png"
  }
  option {
    name = "France (Paris)"
    value = "fr-par"
    icon = "/emojis/1f1eb-1f1f7.png"
  }
  option {
    name = "Germany (Frankfurt)"
    value = "eu-central"
    icon = "/emojis/1f1e9-1f1ea.png"
  }
  option {
    name = "India (Chennai)"
    value = "in-maa"
    icon = "/emojis/1f1ee-1f1f3.png"
  }
  option {
    name = "India (Mumbai)"
    value = "ap-west"
    icon = "/emojis/1f1ee-1f1f3.png"
  }
  option {
    name = "* Indonesia (Jakara)"
    value = "id-cgk"
    icon = "/emojis/1f1ee-1f1e9.png"
  }
  option {
    name = "Italy (Milan)"
    value = "it-mil"
    icon = "/emojis/1f1ee-1f1f9.png"
  }
  option {
    name = "Japan (Osaka)"
    value = "jp-osa"
    icon = "/emojis/1f1ef-1f1f5.png"
  }
  option {
    name = "Japan (Tokyo)"
    value = "ap-northeast"
    icon = "/emojis/1f1ef-1f1f5.png"
  }
  option {
    name = "Netherlands (Amsterdam)"
    value = "nl-ams"
    icon = "/emojis/1f1f3-1f1f1.png"
  }
  option {
    name = "Singapore"
    value = "ap-south"
    icon = "/emojis/1f1f8-1f1ec.png"
  }
  option {
    name = "Sweden (Stockholm)"
    value = "se-sto"
    icon = "/emojis/1f1f8-1f1ea.png"
  }
  option {
    name = "United Kingdom (London)"
    value = "eu-west"
    icon = "/emojis/1f1ec-1f1e7.png"
  }
  option {
    name = "United States (California, Fremont)"
    value = "us-west"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (California, Los Angeles)"
    value = "us-lax"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Florida)"
    value = "us-mia"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Georgia)"
    value = "us-southeast"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Illinois)"
    value = "us-ord"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (New Jersey)"
    value = "us-east"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Texas)"
    value = "us-central"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Washington D.C.)"
    value = "us-iad"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
  option {
    name = "United States (Washington)"
    value = "us-sea"
    icon = "/emojis/1f1fa-1f1f8.png"
  }
}

data "coder_parameter" "linode_image" {
  name = "linode_image"
  display_name = "Linode Image"
  description = "Which Linode Image would you like to use?"
  default = "linode/ubuntu22.04"
  type = "string"
  mutable = false
  option {
    name = "AlmaLinux 8"
    value = "linode/almalinux8"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/almalinux.svg"
  }
  option {
    name = "AlmaLinux 9"
    value = "linode/almalinux9"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/almalinux.svg"
  }
  option {
    name = "Alpine 3.16"
    value = "linode/alpine3.16"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/alpinelinux.svg"
  }
  option {
    name = "Alpine 3.17"
    value = "linode/alpine3.17"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/alpinelinux.svg"
  }
  option {
    name = "Alpine 3.18"
    value = "linode/alpine3.18"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/alpinelinux.svg"
  }
  option {
    name = "Alpine 3.19"
    value = "linode/alpine3.19"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/alpinelinux.svg"
  }
  option {
    name = "Arch"
    value = "linode/arch"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/archlinux.svg"
  }
  option {
    name = "CentOS 7"
    value = "node/centos7"
    icon = "/icon/centos.svg"
  }
  option {
    name = "CentOS Stream 8"
    value = "linode/centos-stream8"
    icon = "/icon/centos.svg"
  }
  option {
    name = "CentOS Stream 9"
    value = "linode/centos-stream9"
    icon = "/icon/centos.svg"
  }
  option {
    name = "Debian 9"
    value = "linode/debian9"
    icon = "/icon/debian.svg"
  }
  option {
    name = "Debian 10"
    value = "linode/debian10"
    icon = "/icon/debian.svg"
  }
  option {
    name = "Debian 11"
    value = "linode/debian11"
    icon = "/icon/debian.svg"
  }
  option {
    name = "Debian 12"
    value = "linode/debian12"
    icon = "/icon/debian.svg"
  }
  option {
    name = "Fedora 38"
    value = "linode/fedora38"
    icon = "/icon/fedora.svg"
  }
  option {
    name = "Fedora 39"
    value = "linode/fedora39"
    icon = "/icon/fedora.svg"
  }
  option {
    name = "Gentoo"
    value = "linode/gentoo"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/gentoo.svg"
  }
  option {
    name = "Kali"
    value = "linode/kali"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kali.svg"
  }
  option {
    name = "Kube 1.26.1 (Debian 11)"
    value = "linode/debian11-kube-v1.26.1"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "Kube 1.26.3 (Debian 11)"
    value = "linode/debian11-kube-v1.26.3"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "Kube 1.26.12 (Debian 11)"
    value = "linode/debian11-kube-v1.26.12"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "Kube 1.27.5 (Debian 11)"
    value = "linode/debian11-kube-v1.27.5"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "Kube 1.27.9 (Debian 11)"
    value = "linode/debian11-kube-v1.27.9"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "Kube 1.28.3 (Debian 11)"
    value = "linode/debian11-kube-v1.28.3"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/kubernetes.svg"
  }
  option {
    name = "OpenSUSE Leap 15.5"
    value = "linode/opensuse15.5"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/opensuse.svg"
  }
  option {
    name = "Rocky Linux 8"
    value = "linode/rocky8"
    icon = "/icon/rockylinux.svg"
  }
  option {
    name = "Rocky Linux 9"
    value = "linode/rocky9"
    icon = "/icon/rockylinux.svg"
  }
  option {
    name = "Slackware 15.0"
    value = "linode/slackware15.0"
    icon = "https://raw.githubusercontent.com/bamhm182/Coder-Templates/main/icons/slackware.svg"
  }
  option {
    name = "Ubuntu 16.04 LTS"
    value = "linode/ubuntu16.04lts"
    icon = "/icon/ubuntu.svg"
  }
  option {
    name = "Ubuntu 18.04 LTS"
    value = "linode/ubuntu18.04"
    icon = "/icon/ubuntu.svg"
  }
  option {
    name = "Ubuntu 20.04 LTS"
    value = "linode/ubuntu20.04"
    icon = "/icon/ubuntu.svg"
  }
  option {
    name = "Ubuntu 22.04 LTS"
    value = "linode/ubuntu22.04"
    icon = "/icon/ubuntu.svg"
  }
  option {
    name = "Ubuntu 23.04"
    value = "linode/ubuntu23.04"
    icon = "/icon/ubuntu.svg"
  }
  option {
    name = "Ubuntu 23.10"
    value = "linode/ubuntu23.10"
    icon = "/icon/ubuntu.svg"
  }
}
