---
title: My second Linux From Scratch system
date: "2026-01-02"
---

> In this blog post, I will refer to [Linux From Scratch](https://www.linuxfromscratch.org) by writing "LFS".

Since I only use my ThinkPad L390, I decided to build a new LFS system on my other laptop, an Acer Swift 5, to make it a functional, minimalist and controlled station. Indeed, I don't use this laptop anymore, I find it much less pleasant than my ThinkPad, so I might as well have some fun with it.

In this blog post I'm not going to talk about every step in the process of building an LFS system, just the ones I find relevant to my hardware and experience.

## Background

Currently, on my ThinkPad, I use NixOS as my daily main operating system. I also have [the LFS system](/posts/lfs-first) that I built a few months ago, which is still functional but which I rarely use.
Then there's the target laptop, my Acer, on which I also have NixOS, the computer isn't used but it's perfectly functional.

## My goal

My goal is to erase all the data on the storage device (NVMe SSD), then install [LFS 12.4-systemd](https://www.linuxfromscratch.org/lfs/view/stable-systemd/) and [BLFS 12.4-systemd](https://www.linuxfromscratch.org/blfs/view/stable-systemd/) in order to have a graphics environment that allows me to have a light and fast desktop environment.

## Preparation

First of all, I erased all data from the SSD in a clean way, using [shredos.x86_64](https://github.com/PartialVolume/shredos.x86_64). I also tested the memory with [Memtest86+](https://www.memtest.org/).

### Host system

Basically, I wanted to dedicate all the SSD space to LFS, so I chose to build my system on the live version of Debian 13. To do this, I downloaded a Debian 13 disk image, checked its authenticity and installed it on my USB key, on the partition used by Ventoy.

### Partitioning

My computer uses UEFI, so I had to create a dedicated partition in which to write the necessary EFI applications, with the file system mounted in /boot/efi. Below is a summary of the partitions created from Debian 13 on my SSD to accommodate LFS.

```text
NAME        FSTYPE        SIZE MOUNTPOINTS
nvme0n1                 476,9G 
├─nvme0n1p1 vfat          500M /boot
├─nvme0n1p2 vfat          200M /boot/efi
├─nvme0n1p3 ext4          100G /home
├─nvme0n1p4 ext4           60G /sources
├─nvme0n1p5 ext4          100G /
└─nvme0n1p6 swap            2G [SWAP]
```

This is the result of the following command line.

```bash
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINTS
```

For the /tmp folder, I chose to let systemd manage it using tmpfs.

## Building the LFS system and minimal configuration

Once my disk was partitioned, I was able to build a minimal LFS system, with basic programs, standard folders, users, minimal configuration, etc.

## Building Linux

To build Linux, I had to find and download the firmware for my hardware, then activate the drivers as modules in the Linux configuration. While configuring the kernel, I discovered a rather useful configuration item called CONFIG_IKCONFIG_PROC, which exposes the configuration options that were used to build the currently running kernel in /proc/config.gz.

## GRUB configuration

Unlike my previous LFS system, where I used the GRUB managed by NixOS, this time I have to build, install and configure it myself. Here's my GRUB configuration.

```text
set default=0
set timeout=5

insmod part_gpt
insmod ext2

search --set=root --fs-uuid 8944-1D1F

insmod efi_gop
insmod efi_uga
if loadfont /boot/grub/fonts/unicode.pf2; then
  terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 6.16.1-lfs-12.4-systemd" {
  linux   /vmlinuz-6.16.1-lfs-12.4-systemd root=PARTUUID=7d866f2d-54b3-43e1-83d7-9fe18cf910d3
  initrd /microcode.img
}

menuentry "Firmware Setup" {
  fwsetup
}
```

## BLFS and desktop environment

After verification, the system boots and works as expected. Now all that's left to do is follow BLFS through to build XFCE, installing some additional items for security and the like along the way.

Unlike my first iteration of LFS and BLFS, I took care to run all the test suites and installed as many optional dependencies as possible. This paid off, as I had almost no errors during project builds, installations and executions.

Finally, I added some essential programs, a web browser, a sound mixer, a text editor and so on. Here's my final desktop environment.

<center>
<img src="/lfs-second-xfce4.png" class="img-center">
</center>

## Conclusion

Once again, an interesting experiment that lets me use my forgotten hardware and build a fully customized system.
