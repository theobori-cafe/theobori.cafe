---
title: Writing an Emacs package based on nix-converter
date: "2026-01-18"
---

## Introduction

As a GNU Emacs user, I spend most of my time there. Not long ago I released version 1.0.0 of [nix-converter](https://github.com/theobori/nix-converter), a CLI for converting Nix code into a configuration language and vice-versa. I thought it might be fun to be able to use it through Emacs' features rather than through a command-line shell.

The aim of this post is to show the interesting things you can do with Emacs, it won't necessarily cover all the technical aspects of the [project](https://github.com/theobori/nix-converter.el).

Also, in this post, Emacs refers to GNU Emacs and ELisp stands for Emacs Lisp.

## My goal

My goal is to write an Emacs package for at least version 30.1 that allows me to use [nix-converter](https://github.com/theobori/nix-converter) through ELisp. In particular, I'd like to have a feature that lets me convert the active region directly by modifying the Emacs buffer.

## Learning Lisp/ELisp

Of course I use Emacs, and I've spent some time configuring it, but before starting this [project](https://github.com/theobori/nix-converter.el) I wasn't able to write in ELisp in a meaningful way, I didn't know enough about the language and how it worked.

That's why I decided to deepen my ELisp theory and practice. For that, I reread my few notes from last year on Emacs Lisp Intro and Masterring Emacs, then actively watched [System crafter](https://systemcrafters.net)'s [youtube video series](https://www.youtube.com/watch?v=RQK_DaaX34Q&list=PLEoMzSkcN8oPQtn7FQEF3D7sroZbXuPZ7) to learn ELisp.

## Writing the project

After improving my knowledge of ELisp, I was able to start writing the [project](https://github.com/theobori/nix-converter.el), which in the end went rather well. I haven't encountered many problems, apart from one that forced me to transform the path to the source file into an absolute path.

I was able to write a coherent ELisp interface that allowed me to use [nix-converter](https://github.com/theobori/nix-converter)'s functionality.

## Results

I managed to achieve my goal, which was to convert the active region directly by modifying an Emacs buffer. Below is a gif showing this functionality with a conversion from YAML to Nix, without additional nix-converter flags.

<center>
<img src="/nix-converter-el-result.gif" class="img-center">
</center>

The package provides other features such as ad-hoc expression conversion. Below is a gif showing an on-the-fly conversion from Nix to YAML.

<center>
<img src="/nix-converter-el-result2.gif" class="img-center">
</center>

## Conclusion

It was a stimulating and enriching experience that introduced me to Emacs and its language, Emacs Lisp, in greater detail. I love ELisp more than ever, and I'm looking forward to writing more! If you want more technical details about the project feel free to check out the [GitHub repository](https://github.com/theobori/nix-converter.el).
