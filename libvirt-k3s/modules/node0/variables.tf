locals {
  instance_name = lower("coder-${var.owner}-${var.ws_name}-node${var.ws_number}")
}

variable "agent_id" {
  description = "Coder Agent ID"
  type        = string
}

variable "agent_token" {
  description = "Coder Agent Token"
  type        = string
}

variable "coder_url" {
  description = "URL to access Coder"
  type        = string
}

variable "cpu" {
  default     = 1
  description = "CPU Core count"
  type        = number
}

variable "flavor" {
  default     = "k3s"
  description = "Type of Kubernetes deployment (k3s, k8s)"
  type        = string
}

variable "network_id" {
  description = "Network ID for the internal network"
  type = string
}

variable "owner" {
  description = "User who owns the VM"
  type        = string
}

variable "ram" {
  default     = 1024
  description = "Amount of RAM in MB"
  type        = string
}

variable "type" {
  default     = "agent"
  description = "Kubernetes role of the node"
  type        = string
}

variable "ws_name" {
  description = "Name of the VM workspace"
  type        = string
}

variable "ws_number" {
  default     = 0
  description = "VM Number"
  type        = string
}
