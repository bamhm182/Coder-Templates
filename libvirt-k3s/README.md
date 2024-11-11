---
display_name: K3s (libvirt)
description: Create a K3s cluster on libvirt
default_ttl: 24h
icon: https://raw.githubusercontent.com/loganmarchione/homelab-svg-assets/745e5d9249f2c847d58de5f1fd7ba4de2f63918e/assets/k3s.svg
maintainer_github: bamhm182
verified: true
tags: [linux, kvm, libvirt, k3s, kubernetes]
---

# K3s (libvirt)

Create a K3s cluster on libvirt.

## Providers

This template makes use of the following providers and associated environmental variables:

* [coder/coder](https://registry.terraform.io/providers/coder/coder/latest/docs): Used to facilitate Coder
* [loafoe/htpasswd](https://registry.terraform.io/providers/loafoe/htpasswd/latest/docs): Used to generate password hashes
* [dmacvicar/libvirt](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs): Used to manage libvirt/QEMU/KVM
  * LIBVIRT_DEFAULT_URI: The libvirt URI used to configure virtual machines (Ex: qemu+ssh://user:password@box/session)
* [hashicorp/random](https://registry.terraform.io/providers/hashicorp/random/latest/docs): Used to generate random passwords
* [hashicorp/tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs): Used to generate SSH Keys

