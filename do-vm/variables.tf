variable "step1_do_project_id" {
  type        = string
  description = <<-EOF
    Enter project ID

      $ doctl projects list
  EOF
  sensitive   = true

  validation {
    # make sure length of alphanumeric string is 36
    condition     = length(var.step1_do_project_id) == 36
    error_message = "Invalid Digital Ocean Project ID."
  }

}

variable "step2_do_admin_ssh_key" {
  type        = number
  description = <<-EOF
    Enter admin SSH key ID (some Droplet images require an SSH key to be set):

    Can be set to "0" for no key.

    Note: Setting this to zero will break Fedora images and notify root passwords via email.

      $ doctl compute ssh-key list
  EOF
  sensitive   = true

  validation {
    condition     = var.step2_do_admin_ssh_key >= 0
    error_message = "Invalid Digital Ocean SSH key ID, a number is required."
  }
}
