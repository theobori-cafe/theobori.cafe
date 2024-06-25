---
title: DOOM Terraform chaos engineering
date: "2023-06-03"
---

I first saw [kubedoom](https://github.com/storax/kubedoom) and thought it was pretty cool, so I decided to do the same for Terraform, knowing that I was working with it for professional projects. 

The principle is very simple, each enemy represents a Terraform resource, if an enemy dies, the associated resource is destroyed.
&nbsp;

## How does it work?

The main program is `terraform-doom`, which creates a UNIX socket, listens to it and simultaneously launches an X11 virtual server (Xvfb), a VNC server (x11vnc) attached to this X session and `psdoom` (DOOM writing to the UNIX socket). 

The binaries `Xvfb` and `x11vnc` are used to create a cross-platform graphical access to `psdoom` inside the container.
&nbsp;
At runtime `psdoom` will continuously write to the UNIX socket to signal `terraform-doom` to send Terraform resource information. When an enemy is killed, `psdoom` writes the associated resource name to the socket.
&nbsp;
Everything we've just described will be encapsulated in a Docker container.
&nbsp;

<p align="center">
    <img src="/terraform_doom_graph.png" style="max-width: 100%; width: auto;">
</p>

&nbsp;

## Demonstration

This demonstration has been realized with the example Terraform project, every steps to reproduce it are detailed in the README file on the repository.
&nbsp;
<p align="center" width="100%">
    <video controls width="80%">
        <source src="/doom_terraform_demo.mp4" type="video/mp4">
        <a href="/tf-doom_terraform_demo.mp4">MP4</a>
    </video>
</p>

&nbsp;

## Links

[https://github.com/theobori/terraform-doom](https://github.com/theobori/terraform-doom)

&nbsp;
