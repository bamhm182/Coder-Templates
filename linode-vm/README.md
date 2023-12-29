---
display_name: Virtual Machine (Linode)
description: Create a Virtual Machine on Linode
default_ttl: 1h
icon: https://raw.githubusercontent.com/bamhm182/Coder-Templates/wip-initial/icons/akamai.svg
maintainer_github: bamhm182
tags: [vm, linux, linode]
---

Create a Virtual Machine on Linode.

# Providers

* linode
  * LINODE_TOKEN: API Token for Linode

## Linode API Token

The Linode API Token should have the following scope. Items not included should be `None`.

* Images: `Read Only`
* Linodes: `Read/Write`
* StackScripts: `Read/Write`
* Volumes: `Read/Write`

## Reasons you might not want to use Linode for Coder

- Account Management doesn't really exist, so you'd have to share an admin account to manage your resources
- Notification Settings are less granular than they are elsewhere, so you'll recieve a TON of emails
- It takes a long time to create VMs (4+ minutes) when compared to other services
