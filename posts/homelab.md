---
title: My homelab
date: "2024-06-06"
---

I've got an old laptop that I don't use anymore, so I thought I'd turn it into a server and deploy some free, open-source web services on it.

The aim is to create a private homelab, i.e. the machine should only be accessible via the local network. None of the services are exposed to the Internet, with the exception of Wireguard, which lets me access the services from the outside.

The aim of this post is to present the main steps I've taken and explain how the homelab works.

My laptop is an [ASUS ROG G750](https://laptopmedia.com/series/asus-rog-g750/) with 8GB of memory and 2 HDDs of around 600GB each. It hasn't been used for about five or six years and the battery is dead.


## First steps

First, I decided to make an old USB key bootable. I install [Ventoy](https://www.ventoy.net/) on it to be able to load different image disks (ISO) without having to rewrite each time directly on the USB key.

I put [Memtest86+](https://www.memtest.org/) to test the memory, [shredos.x86_64](https://github.com/PartialVolume/shredos.x86_64) to wipe the HDDs and finally [Debian 12](https://cdimage.debian.org/debian-cd/12.5.0/amd64/iso-cd/) which will be the main OS.

So when I boot on the USB key, it loads the "multiboot" boot-loader (Ventoy) and I can then load one of the three programs.


## Pre configuration

To be able to deploy the system configuration and reproduce it later, I'm writing an Ansible playbook and testing it on a local VM (`virt-manager` + KVM).

The entire configuration is available at the bottom of the page.


## TLS certificates

I want communication with web applications to be encrypted and secure, so I need an HTTPS server, so I need TLS certificates and, to make things easier, a domain name.

For the domain name I used [Duck DNS](https://www.duckdns.org/) and reserved the sub-domain [theobori.duckdns.org](https://theobori.duckdns.org) which for the moment corresponds to the IPv4 of my virtual machine accessible only from the host system.

In fact, I only need to manage one certificate with two SANs:
- `theobori.duckdns.org`
- `*.theobori.duckdns.org`


## Services

Every application is deployed with the Ansible playbook are conteuneurized and managed with Docker.

They are accessible only through port 443 managed by [Traefik](https://traefik.io/). Each sub-domain of [theobori.duckdns.org](https://theobori.duckdns.org) corresponds to a service, with the exception of the homepage, which is associated with the domain itself.


## Firewall

To filter incoming network traffic, I manipulate iptables with the ufw tool. There are only four ports open as declared below in the Ansible playbook configuration.

```yaml
- role: weareinteractive.ufw
  tags: ufw
  ufw_enabled: true
  ufw_packages: ["ufw"]
  ufw_rules:
  - logging: "full"
  - rule: allow
      to_port: "443"
  - rule: allow
      to_port: "80"
  - rule: allow
    {% raw %} to_port: "{{ ssh_port }}" {% endraw %}
  # Wireguard
  - rule: allow
      to_port: "51820"
      proto: udp
  # Delete default rule
  - rule: allow
      name: Anywhere
      delete: true
  ufw_manage_config: true
  ufw_config:
  IPV6: "yes"
  DEFAULT_INPUT_POLICY: DROP
  DEFAULT_OUTPUT_POLICY: ACCEPT
  DEFAULT_FORWARD_POLICY: DROP
  DEFAULT_APPLICATION_POLICY: SKIP
  MANAGE_BUILTINS: "no"
  IPT_SYSCTL: /etc/ufw/sysctl.conf
  IPT_MODULES: ""
```


## Identity provider

Services with integration for protocols to verify user identity or determine permissions are all linked to the [Authentik](https://goauthentik.io/) user directory.

I needed OAuth2 for [Portainer](https://www.portainer.io/) and LDAP for several other services such as [Owncloud](https://owncloud.com/).

If I remember correctly, the OAuth2 Outpost is embedded in the application by default, whereas the LDAP Outpost had to be configured with specific parameters for Docker.

Here's a diagram of several services trying to retrieve the identity of an [Authentik](https://goauthentik.io/) user.



<p align="center">
  <img src="/authentik_users.png" class="img-center">
</p>



## Access management

With [Authentik](https://goauthentik.io/), group policies have been created to authorize only certain groups of users to access certain services.

For example, for [Jellyfin](https://jellyfin.org/), only users in the `Jellyfin` group are authorized to connect.

In this way, I was able to secure all administration services by authorizing only users in groups reserved for administration.

I also used [Traefik](https://traefik.io/) and [Authentik](https://goauthentik.io/) to secure access to services not protected by authentication.

I added middleware to the reverse proxy to enable HTTP ForwardAuth with [Authentik](https://goauthentik.io/). In practical terms, this places a connection portal in front of the targeted web services.

Let's say I want to access [duplicati.theobori.duckdns.org](https://duplicati.theobori.duckdns.org), it could be schematized as follows.


<p align="center">
  <img src="/authentik_proxy.png" class="img-center">
</p>


## Media stack

One of the main objectives was to be able to manage movies and series and watch them from any device on the local network.

So I set up a stack for managing and downloading media, which would then be streamed to devices by [Jellyfin](https://jellyfin.org/).

Here's what the media stack looks like.


<p align="center">
  <img src="/media_stack.png" class="img-center">
</p>


## Backup and restore

To back up container data, I use [Duplicati](https://duplicati.com/). It lets you encrypt data and manage retention very easily via a web interface.

These backups can then be restored on my old computer.


## Monitoring

To keep abreast of service status, I've opted for [Uptime Kuma](https://uptime.kuma.pet/), which will alert me via Discord when a service is down for n seconds.

I also have a [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/) stack that lets me collect metrics on the system and on Docker containers. As for [Uptime Kuma](https://uptime.kuma.pet/), I'm alerted by Discord according to limits defined for RAM and available storage space, for example.

This is how the monitoring stack looks.

<p align="center" width="100%">
  <img src="/monitoring_stack.png" class="img-center">
</p>

## Final home page

Here's an overview of the dashboard, featuring all the services exposed to the local network. In a way it's the end result of service implementation.

<p align="center" width="100%">
  <img src="/dashy.png" width="650px" class="img-center">
</p>

## Links

[https://github.com/theobori/homelab](https://github.com/theobori/homelab)
