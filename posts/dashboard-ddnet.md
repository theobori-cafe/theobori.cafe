---
title: Emacs dashboard DDNet integration
date: "2026-05-12"
---

## Introduction

Right now, I'm playing a lot of [Teeworlds](https://teeworlds.com/) on [DDNet](https://ddnet.org) servers. It turns out I also use Emacs a lot, for example, to write this blog post. I know that DDNet publicly displays statistics about the players on their servers on the web. I know how to write ELisp, and people have written packages that allow you to make web requests. This means it’s possible to retrieve my DDNet statistics and display them in my Emacs window.

## My goal

I’d like to be able to display my DDNet statistics,such as my points, my most recently completed maps, my latest activities, etc. in my Emacs dashboard.

## Emacs package

The ideal solution in this context was to create a new Emacs package called [dashboard-ddnet](https://github.com/theobori/dashboard-ddnet). It contains functions that have been added to `dashboard-item-generators`. These functions are used by the dashboard to insert sections containing statistics about a specific DDNet player. Below is an example configuration for using the package.

```emacs-lisp
(use-package dashboard-ddnet
  :straight (dashboard-ddnet :type git
			     :host github
			     :repo "theobori/dashboard-ddnet")
  :custom
  (dashboard-ddnet-player-name "brainless tee")
  (dashboard-ddnet-cache-ttl 600))

(use-package dashboard
  :custom
  (dashboard-center-content t)
  (dashboard-set-navigator t)
  (dashboard-items '((ddnet-player-general-informations . 5)
					 (ddnet-player-last-finishes . 5)
					 (ddnet-player-favorite-partners . 5)
					 (ddnet-player-last-activity . 5)))
  :config
  (setq initial-buffer-choice (lambda ()
							  (get-buffer-create "*dashboard*")
							  (dashboard-refresh-buffer))))
```

Straight is used because the package is not published in an Emacs package archive. Feel free to adapt this configuration if you wish.

## Overview

Here is what the dashboard might look like with dashboard-ddnet items.

<center>
<img src="/dashboard-ddnet-screenshot.png" class="img-center">
</center>

Most of the elements are `push-button` widgets, so they are clickable and open the URLs associated with these elements in an external web browser.

## Conclusion

It was interesting to dig into the dashboard source code to understand how the package works and handles certain things, such as the icons associated with certain sections.
