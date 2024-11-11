data "coder_parameter" "kube_flacor" {
  name         = "kube_flavor"
  display_name = "Kubernetes Type"
  description  = "Whether to use k3s or k8s"
  default      = "k3s"
  type         = "string"
  icon         = "/icon/k8s.png"
  mutable      = false
  order        = 0

  option {
    name  = "k3s"
    value = "k3s"
  }
  option {
    name  = "k8s"
    value = "k8s"
  }
}

data "coder_parameter" "cpu_count" {
  name         = "cpu_count"
  display_name = "CPU Count"
  description  = "Number of CPU Cores per node"
  default      = "1"
  type         = "number"
  icon         = "/icon/memory.svg"
  mutable      = true
  order        = 1

  validation {
    min       = 1
    max       = 4
    monotonic = "increasing"
  }
}

data "coder_parameter" "ram_amount" {
  name         = "ram_amount"
  display_name = "RAM Amount"
  description  = "Amount of RAM per node (in GB)"
  default      = "1"
  type         = "number"
  icon         = "/icon/container.svg"
  mutable      = true
  order        = 2

  validation {
    min       = 1
    max       = 4
    monotonic = "increasing"
  }
}
