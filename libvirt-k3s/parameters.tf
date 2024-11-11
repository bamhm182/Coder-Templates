data "coder_parameter" "node_count" {
  name      = "node_count"
  display_name = "Node Count"
  description  = "Number of Nodes in the K3s Cluster"
  default      = "2"
  type         = "number"
  icon         = "/icon/widgets.svg"
  mutable      = true
  order        = 0

  validation {
    min       = 1
    max       = 5
    monotonic = "increasing"
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
