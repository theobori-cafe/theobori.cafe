---
title: Porting Plan 9 applications to UNIX
date: "2026-01-09"
---

## Introduction

I wanted to play Sudoku, so I looked for a graphical application to play it, something light and simple, but I couldn't find anything. There is [GNOME Sudoku](https://gitlab.gnome.org/GNOME/gnome-sudoku), but I don't like GNOME and I don't want to have GTK applications, so I didn't install it and stopped my search.

Later, while hanging out on the mastodon merveilles.town instance, I found a post with a screenshot showing a graphical Sudoku running on Plan 9. I really liked its aesthetics, colors and simplicity.

The problem is, I use NixOS on a daily basis and the application isn't compatible with UNIX, only with Plan 9. So I decided to create a project to port Plan 9 applications to UNIX.

## My goal

My main goal is to be able to play Plan 9 Sudoku on my UNIX system, but also to be able to run other Plan 9 applications, such as `catclock`.

## Strategy

There is a project [Plan 9 from User Space](https://9fans.github.io/plan9port) (plan9port) which has ported many Plan 9 programs to UNIX systems, including the main Plan 9 libraries.

The idea is to make the desired Plan 9 programs compatible with plan9port and adapt them if necessary.

## Getting started

To build the project you need GNU Make, [Plan 9 from User Space](https://github.com/9fans/plan9port) and its dependencies for building programs (compiler, linker, etc.). Then you can run the following command line.

```bash
export PREFIX=/usr
make && make install # Build and install every project
```

## Lifecycle management

Each ported program is treated as a project in its own right, with a dedicated folder at the project root, containing the source files, an mkfile with the `all`,`clean`,`install` and `nuke` targets, and a Makefile that serves as the interface to the mkfile. The design of the ported projects, their folders and files is such that the lifecycle of each of them is as independent as possible.

The `PREFIX` environment variable is at the heart of ported program lifecycle management. Its value defines the prefix of their installation path, and is used by mkfiles, while Makefiles provide a default value.

The `PREFIX` value SHOULD be the same for all targets.

### Root mkfile and Makefile

The mkfile and Makefile at the root of the project enable all projects to be managed together. So, for example, the command line below will build and install projects in the `/tmp` folder.

```bash
export PREFIX=/tmp
make clean && make install
```

Without make, with mk.

```bash
export PREFIX=/tmp
9 mk clean && 9 mk install
```

Then you can, for example, launch a catclock with the following command line.

```bash
9 /tmp/bin/catclock
```

## Source code

The code for ported projects was retrieved from [https://9p.io/sources/plan9](https://9p.io/sources/plan9) and [9front](https://git.9front.org/plan9front/9front/30d6e6879e9acff30267a146ecb956ac470a38db/files.html) for projects that do not exist in [Plan 9](https://9p.io/plan9/).

### Modifying

To enable projects to be built, installed and run, modifications have been made to the source code. Some of these fix problems of logic, others are necessary to keep the construction through GNU Make coherent.

## Compatibility

Builds and installation and project execution have so far only been tested for the `x86_64-linux` platform.

Builds and installation are tested using a GitHub Action [workflow](https://github.com/theobori/9ports/blob/main/.github/workflows/check_then_build.yml) for `x86_64-linux`, `aarch64-linux` and `aarch64-darwin` platforms.

## Nix

A Nix Flake is provided, exposing Nix packages representing each of the ported projects and the packages named `all` and `default` enabling them to be managed together.

For example, you can launch a catclock with the following command line.

```bash
nix run github:theobori/9ports#catclock
```

## Results

Below are `sudoku` and some other graphics applications running on my NixOS system.

<center>
<img src="/9ports-running-applications.png" class="img-center">
</center>

## Contributing

Anyone is free to contribute to the source code, many projects have still not been ported. For more details, please visit the [GitHub repository](https://github.com/theobori/9ports).

## Conclusion

I can now play Sudoku on my UNIX system. I'm really enjoying the 9ports project, and I'm thinking of porting other applications, like those on the Plan 9 forks, such as 9front.
