---
display_name: Linux (libvirt)
description: Create a Linux Virtual Machine with libvirt
default_ttl: 24h
icon: /emojis/1f427.png
maintainer_github: bamhm182
verified: true
tags: [linux, kvm, libvirt]
---

# Virtual Machine (libvirt)

Create a Linux Virtual Machine with libvirt.

## Providers

This template makes use of the following providers and associated environmental variables:

* [coder/coder](https://registry.terraform.io/providers/coder/coder/latest/docs): Used to facilitate Coder
* [bamhm182/guacamole](https://registry.terraform.io/providers/bamhm182/guacamole/latest/docs): Used to provide RDP/SSH
  * GUACAMOLE_URL: The URL that will be configured
  * GUACAMOLE_USERNAME: Username of the user used to interact with the Guacamole API
  * GUACAMOLE_PASSWORD: Password for the user used to interact with the Guacamole API
* [loafoe/htpasswd](https://registry.terraform.io/providers/loafoe/htpasswd/latest/docs): Used to generate password hashes
* [dmacvicar/libvirt](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs): Used to manage libvirt/QEMU/KVM
  * LIBVIRT_DEFAULT_URI: The libvirt URI used to configure virtual machines (Ex: qemu+ssh://user:password@box/session)
* [hashicorp/random](https://registry.terraform.io/providers/hashicorp/random/latest/docs): Used to generate random passwords
* [hashicorp/tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs): Used to generate SSH Keys

