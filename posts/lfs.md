---
title: My Linux From Scratch system
date: "2025-03-29"
---

> In this blog post, I will refer to [Linux From Scratch](https://www.linuxfromscratch.org) by writing "LFS".

I heard about LFS by stumbling across a [podcast](https://www.youtube.com/watch?v=TkkKNfYKJJg) by Brodie Robertson. I've been curious and made me want to build my own Linux system.

## What is LFS?

It's a book that explains how to build your own Linux system from scratch using a host system. An interesting feature is that everything is built from source code.

## My objectives

In reading LFS, I have some very specific goals. I'd like my system to be able to run my favorite games, i.e. [DDNet](https://ddnet.org/) and Quake I. To do this, I'll need a kernel that can communicate with my hardware, at least the video, audio and network parts, so that I can access the Internet, etc.

I'd also like to have a simple, lightweight desktop environment based on the graphics server [Xorg](https://www.x.org/wiki/).

And most important of all, I'd like to be able to boot into my system directly on my computer.

## Building LFS

So I started reading the book and setting up my system. More precisely, I chose [version 12.2 with systemd (French version)](https://fr.linuxfromscratch.org/view/lfs-12.2-systemd-fr/) as init daemon and with Linux version 6.10.5. In this section, I'm not going to reexplain all the steps in the book, just highlight the most important ones in my opinion.

### Disk partitioning

I chose to make a single 40GiB ext4 partition on my laptop's hard disk. I declared it in my [NixOS](https://nixos.org) configuration, with partitioning handled by the [NixOS](https://nixos.org) [disko](https://github.com/nix-community/disko) module.

```nix
lfs = {
  name = "LFS";
  size = "40G";
  content = {
	type = "filesystem";
	format = "ext4";
	mountpoint = "/mnt/lfs";
  };
};
```

### Compiling the compiler compiling a compiler

An important part of LFS is cross-compiling. The aim is to build the tools of the construction chain dedicated to my LFS system. This cross-compilation is "false", i.e. in the end, the hardware of my host system and that of my LFS system are the same. Only the target system changes.

Here's a diagram representing the cross-compilation steps, where each rectangle represents a compiler containing a source platform to destination platform relationship.

<center>
    <img src="/lfs_cross-compilation.png" class="img-center">
</center>

### Basic softwares and configuration

After entering my new system (chroot), I was able to establish a base.

I installed all the basic tools you'd want on a Linux system and wrote configuration files for the various applications and services (systemd, network, shells, time, language, etc.).

### Linux

I built Linux by passing the right values to its parameters, so as to be as compatible as possible with my hardware.

I activated the right drivers to communicate with my network card and audio hardware. By default, I was missing a few firmwares that needed to be loaded, so I embedded them in the kernel.

Once built and installed on my LFS system, all that's left to do is load Linux.

### Boot

To be able to boot on my LFS system, I added an entry for the GRUB managed by my main [NixOS](https://nixos.org) system. To do this, I rebuilt my [NixOS](https://nixos.org) system using os-pober, as shown below.

```nix
loader.grub = {
  useOSProber = true;
};
```

## Beyond LFS

Now that I have a basic system that I can boot, the goal is to have a desktop environment before I can play.

I had to build the entire graphics system [X](https://fr.wikipedia.org/wiki/X_Window_System) and its dependencies, before building the window manager [i3](https://i3wm.org/), then [KDE Plasma 6](https://kde.org/fr/announcements/plasma/6/6.2.0/) and finally [Xfce](https://www.xfce.org).

I'm obviously skipping all the sub-dependencies, network configuration (DHCP client, tools, etc.), security (Linux PAM), etc.

Below is an overview of my main desktop envinronnement.

<center>
    <img src="/lfs_xfce.png" class="img-center">
</center>


So I end up on [Xfce](https://www.xfce.org), download the latest version of [DDNet](https://ddnet.org), patch the source code as I didn't want to use the `libnotify` library, compile and launch the game.

The application is functional, I can join a game via the Internet and the game sound comes out of my laptop speakers! Below is a screenshot with the game running.

<center>
    <img src="/lfs_ddnet.png" class="img-center">
</center>

The same for Quake I through [VkQuake](https://github.com/Novum/vkQuake), a preview below.

<center>
    <img src="/lfs_quake.png" class="img-center">
</center>

## Little hack

To avoid having to manage all the packages by hand, I decided to install a package manager, but not just any package manager, [Nix](https://github.com/NixOS/nix). It will allow me to have fully functional immutable packages.

I installed it with the [DeterminateSystems](https://github.com/DeterminateSystems/nix-installer) installer.

It allowed me to build very complicated packages such as [Firefox](https://www.mozilla.org/fr/firefox), here's a preview.

<center>
    <img src="/lfs_firefox.png" class="img-center">
</center>

## Is it worth it?

Reading and putting LFS into practice takes a long time, but it's definitely worth it! I was able to learn some very interesting and useful new things about the world of Linux and now I understand more precisely how Linux and UNIX systems work.

I recommend the experience to all curious people who want to have their own Linux system. The result is very satisfying, and it's even possible to use an LFS system as your main system!

## Conclusion

I loved reading the book and setting up everything myself, and I intend to keep my LFS system and continue modifying it.
