---
title: My Gopher webring application
date: "2026-06-13"
---

## Introduction

I've visited many webrings available on the Internet, [the hacker webring](https://ring.acab.dev/), [xxiivv](https://webring.xxiivv.com), [noai](https://baccyflap.com/noai), [geekring](https://geekring.net/), etc. These are all webrings designed for HTTP(S) only, but these days, I visit a lot of Gopher websites. So I wanted to write a Gopher application to implement a Gopher webring. To meet my needs, I created the [ange](https://github.com/theobori/ange) project, pronounced \\ɑ̃ʒ\\, which corresponds to the word angel.

## What is a webring

A webring is a chained list in which each node contains information about a website and its neighbors in the list. Below is a graph representing a webring example.

<center>
<img src="/webring.png" width="50%">
</center>

## My goal

My goal is to build a Gopher application that can manage a persistent webring. Users should be able to submit a request to join, and there should also be an admin section to review user requests.

## Gopher Form

For this project to work, I need to create forms for users. So I wrote the [fleur-form](https://github.com/theobori/fleur-form) project. It's a plugin for the routers in the [fleur](https://github.com/theobori/fleur) project, it allows you to create forms with multiple text fields for the user, which isn't natively possible with Gopher and gophermap. Below is an image of an example form.

<center>
<img src="/fleur-form_example.png" class="img-center">
</center>

## Based on fleur

Ange is primarily based on the fleur framework and the fleur router plugin called fleur-form.

<center>
<img src="/ange-dependencies.png" width="30%">
</center>

## How it works

The system is intentionally quite simple. The chain of Gopherspaces is stored persistently using [SQLite3](https://sqlite.org/). Users can perform operations on the webring via Gopher requests specifying specific paths. Each node of the webring has a unique ID and a unique token. The token can be used by the users to remove their gopherspace from the webring.

For more technical details, please refer to the [project documentation](https://github.com/theobori/ange/blob/main/README.md).

### Webring members

After submitting a request to join the webring, the idea is for users to add a section representing their node in the webring to their website. Here is an example.

```text
1Previous	/webring/previous/your_id	webring-url	70
1Webring title	/	webring-url	70
1Next	/webring/next/your_id	webring-url	70
1Random	/webring/random	webring-url	70
```

## Accessibility

Ange provides a set of features that make it easy to create and manage your own webring. It follows the same approach as the fleur project. It is easy to understand and very simple to set up.

Specifically, someone wishing to use ange to create a Gopher webring would simply need to install ange on their machine using the command line recommended in the project documentation. Then, if necessary, customize the file named `gophermap` in the root of the chosen directory, and finally run ange.

## Overview

Here's what ange looks like with the `gophermap` file provided by the project.

<center>
<img src="/ange-zero-gopherspaces.png" class="img-center">
</center>

And here's an example of Gopherspaces accepted into the webring.

<center>
<img src="/ange-two-gopherspaces.png" class="img-center">
</center>

## Conclusion

Implementing a webring helped me better understand how they generally work, it was pretty fun. During my research, I wasn't able to find any existing Gopher webrings. If you know of any, please feel free to contact me to discuss them.
