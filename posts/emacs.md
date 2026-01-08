---
title: A GNU Emacs experience throught NixOS
date: "2025-02-26"
---

## Introduction

I have always used [VSCode](https://code.visualstudio.com/) as a code editor. I've already tried using [Vim](https://www.vim.org/), but only for testing purposes and not with the aim of changing text editors.

This time, I decided to use a [FLOSS](https://www.gnu.org/philosophy/floss-and-foss.html) code editor in the terminal, the aim being to replace [VSCode](https://code.visualstudio.com/) indefinitely. This blog post is actually written with it.

It is none other than [Emacs](https://www.gnu.org/s/emacs/). For the convenience of writing and reading this post, I'll simply write “Emacs” to designate the [implementation of the GNU](https://www.gnu.org/s/emacs/) project.

## Why

Why did I leave [VSCode](https://code.visualstudio.com/) and decide to switch to [Emacs](https://www.gnu.org/s/emacs/)?

### Leaving VSCode

Because it's a RAM-hungry graphics application. You shouldn't need that much memory to edit text and connect to an LSP server. We're talking about 1.2 GB compared with around 200 MB for the same project.

Also, I don't want all the additional features offered, such as file name and text parsing, to suggest that I download extensions. I simply need a simple, functional text-editing application. I don't enjoy using [VSCode](https://code.visualstudio.com/) anymore, so it's time to say goodbye.

### Choosing Emacs

Of all the text editors out there, I chose [Emacs](https://www.gnu.org/s/emacs/). It's actually much more than that. In the words of [Protesilaos Stavrou](https://protesilaos.com/codelog/2022-03-22-libreplanet-emacs-living-freedom/).
> It is a programmable platform where text editing is one of the main points of interaction.

Indeed, I see [Emacs](https://www.gnu.org/s/emacs/) more as an operating system than as a text editor. The possibilities for configuring and extending it are virtually infinite.

Also, I find it an excellent UNIX citizen. The default keystroke sequences correspond to those used in other applications in the terminal. ar example, the moves in a Linux manual read with the `man` command or those in the results of `fzf`.

Another reason was to be able to modify any behavior, to be able to have an application that corresponds precisely to what you want to have.

## Learning

So I installed [Emacs](https://www.gnu.org/s/emacs/) version 29.4 and started learning how to use it properly.

### Mastering Emacs, Mickey Pertersen

This book explained the important concepts of the application and gave me a solid foundation for getting started with [Emacs](https://www.gnu.org/s/emacs/). Certain chapters, such as “The Theory of Movement” and “The Theory of Editing”, explained to me the best practices for efficient and rapid buffering.

I highly recommend this book for anyone wishing to start learning [Emacs](https://www.gnu.org/s/emacs/).

### Emacs Lisp Intro

I've also read the “Emacs Lisp Intro” written in [Emacs](https://www.gnu.org/s/emacs/) as a manual. Since most of the code is written in [Emacs](https://www.gnu.org/s/emacs/) Lisp, it's essential to understand the language, or at least know how to read it, in order to configure the editor.

For example, I needed to write some to display line numbers at the start of [org-present](https://github.com/rlister/org-present) mode, and to hide them at the end of minor mode execution.

### Environment

As I said earlier, [Emacs](https://www.gnu.org/s/emacs/) is a platform with a whole host of features. This makes it all the more tempting to leave this environment, which offers numerous possibilities, such as organizing a diary, compiling a project, accessing a shell or terminal emulator, making a presentation, taking notes, managing [Emacs](https://www.gnu.org/s/emacs/) modes and packages, etc.

Staying in the same environment made me more productive and faster. For computer development, [Emacs](https://www.gnu.org/s/emacs/) can be configured like an IDE, precisely and fully controlled.

One last very important thing to know is that any piece of [Emacs](https://www.gnu.org/s/emacs/) is documented, meaning that whatever I do or try to do, I can find documentation. [Emacs](https://www.gnu.org/s/emacs/) is its own documentation.

## Configuration

### Via NixOS

Concerning the tool configuration, being on [NixOS](https://nixos.org/), I decided to use the [Emacs](https://www.gnu.org/s/emacs/) module provided by the home-manager. To remain consistent with my current configuration, which is highly modularized, each [Emacs](https://www.gnu.org/s/emacs/) package has its own Nix module.

Here's what the file structure looks like.
```text
modules/home/editors/emacs
├── default.nix
└── packages
    ├── auto-save
    │   └── default.nix
    ├── dashboard
    │   └── default.nix
    ├── dired
    │   └── default.nix
    ├── doom-modeline
    │   └── default.nix
    ├── ivy
    │   └── default.nix
    ├── lsp-mode
    │   ├── bash-language-server
    │   │   └── default.nix
    │   ├── default.nix
    │   ├── dockerfile
    │   │   └── default.nix
    │   ├── gopls
    │   │   └── default.nix
...
```

These modules contain the dependencies, i.e. the [Emacs](https://www.gnu.org/s/emacs/) packages and the [Emacs](https://www.gnu.org/s/emacs/) Lisp configuration.

Here's an example with the [org-superstar](https://github.com/integral-dw/org-superstar-mode) package.

```nix
{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.editors.emacs.packages.org-superstar;
in
{
  options.${namespace}.editors.emacs.packages.org-superstar = {
    enable = mkBoolOpt false "Whether or not to enable the emacs org-superstar package.";
  };

  config = mkIf cfg.enable {
    programs.emacs = {
      extraPackages = (epkgs: [ epkgs.org-superstar ]);
      extraConfig = ''
        (use-package org-superstar
          :ensure t
          :after org
          :hook (org-mode . org-superstar-mode)
          :custom
            (org-superstar-remove-leading-stars t)
            (org-superstar-headline-bullets-list '("⁖" "✿" "▷" "✸")))
      '';
    };
  };
}
```

## Notes taking on Emacs

[Emacs](https://www.gnu.org/s/emacs/) has a major mode called [Org](https://orgmode.org/), which modifies [Emacs](https://www.gnu.org/s/emacs/) behavior to create an environment suited to writing data in org format. It integrates perfectly with [Emacs](https://www.gnu.org/s/emacs/) other features and keeps me in the application.

I used to take my notes with Obsidian. I refactored all my notes and converted them to [Org](https://orgmode.org/) format.

## Conclusion

From now on, I intend to use [Emacs](https://www.gnu.org/s/emacs/) as my main text editor, as well as for note-taking.
