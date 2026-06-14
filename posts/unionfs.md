---
title: A union filesystem in userspace 
date: "2026-06-14"
---

## Introduction

I find the various concepts and philosophy behind [Plan 9](https://p9f.org/) very interesting. About a month ago, I discovered the union directory feature. It involves binding directories to other directories. In practice, you end up with a directory that behaves like a collection of directories. I wanted to try implementing a similar feature for UNIX.

## My goal

The main goal of this project is to have fun and learn about technologies I wasn’t familiar with. Technically, I’d like to write a virtual file system for UNIX that behaves similarly to Plan 9’s union dir. The idea is to have mount points that communicate with a daemon that manages a global mount table. Having a client-server architecture will allow the mount table to be managed even after the mount points have been created.

## Implementation

So, I decided to create a [Python project](https://github.com/theobori/unionfs) on GitHub containing a library and a CLI. The library provides Python code that communicates with [FUSE](https://www.kernel.org/doc/html/next/filesystems/fuse.html) to export a file system to the kernel, a server to manage the global mount table in memory, and functions to communicate with that server. The CLI is a Python application that allows you to manage the mount points of the virtual file system and manipulate the global mount table. Most of the file system operations are inspired by [https://1e.iwp9.org/cready/unfs.pdf](https://1e.iwp9.org/cready/unfs.pdf). For more technical details, please refer to the [project documentation](https://github.com/theobori/unionfs/blob/main/README.md).

## Components

Below are the main components of the project.

### Mount Table

The mount table is a Python object that manages a hash map, where each key is a path corresponding to a mount point, and each value is a custom data structure designed to manage the mounted directories. It has a time complexity of O(1) for each required operation.

### Daemon

This is a server that must be started before mounting the filesystem. It is responsible for managing the global mount table in memory and handling mount and bind requests.

### Mount Points

These export the filesystem to the kernel using FUSE. While running, they communicate with the daemon to update their bound directories.

## Usage example

Personally, I used it to organize Quake mods into a single folder. I ran the commands below.

```bash
mkdir -pv /tmp/union-quake

unionfs daemon --verbose
unionfs mount /tmp/union-quake
unionfs bind /tmp/union-quake ~/quake/ -a
unionfs bind /tmp/union-quake ~/snacks/ -a

vkquake -basedir /tmp/union-quake/
```

And I was able to play my Quake mods, which were spread out across several folders.

## Project Progress

The project is not entirely finished, there are still areas for improvement to explore and tasks to complete. However, it remains functional.

## Conclusion

Although the project isn't quite finished yet, it was cool to create a small protocol dedicated to managing the mount table. I also got to explore FUSE in more detail and learn some new things. I'm pretty happy with the result.
