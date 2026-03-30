---
title: A Transient menu for qBittorrent
date: "2026-03-30"
---

## Introduction

I often use [qBittorrent](https://www.qbittorrent.org/) and I usually manage my files with Emacs, especially my torrent files. One day, while in Dired, I noticed I had some unused torrent files. I wanted to mark them and then use a command to start the downloads, but I realized that this feature didn’t exist. So I had the idea to create an Emacs package that would provide an ELisp API to communicate with the qBittorrent CLI.

## My goal

The goal is to have a simple, intuitive Emacs user interface to communicate with the official qBittorrent CLI and allow me to pass torrent files to qBittorrent from Dired.

## Using Transient

[Transient](https://docs.magit.vc/transient/) is an Emacs library specialized in creating menus for keyboard users. Using Transient will allow me to create a menu for composing a qBittorrent command line, handling the configuration and the actions to be performed.

## API Overview

The Emacs package is called `qbittorrent-transient`. It exposes customizations in a group of the same name, as well as functions and commands. The main entry point is the `qbittorrent-transient` command, which provides access to the Transient menu for qBittorrent. Below are the main Emacs commands.

<center>
<img src="/qbittorrent-transient-commands.png" class="img-center">
</center>

## Results

I’m satisfied with the result; it allows me to pass files marked with Dired to qBittorrent, which was my main goal. Here’s what the Transient menu looks like.

<center>
<img src="/qbittorrent-transient.png" class="img-center">
</center>

## Contributing

Anyone is free to contribute to the source code available at [GitHub repository](https://github.com/theobori/qbittorrent-transient).

## Conclusion

This was a rewarding project to work on; I still love ELisp, which allowed me to create an Emacs user interface that is easy and pleasant to use.
