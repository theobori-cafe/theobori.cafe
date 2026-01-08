---
title: My Gopherspace garden
date: "2026-01-08"
---

## Introduction

Recently, I went back into [Gopherspace](https://fr.wikipedia.org/wiki/Gopher) and saw websites like [baud.baby](gopher://baud.baby) with the phlog named FAX SEX. I found it very elegant and inspiring, so I immersed myself in this universe.

I want to modify my gph files that reflect my website [theobori.cafe](https://theobori.cafe). These files had been automatically translated with a shell script that transforms Markdown into gph. It was syntactically correct, but the format was not very elegant.

## My goal

My primary goal is to refactor my Gopher files. To do this, I want to create a dedicated project that will produce a CLI capable of translating Markdown with a bit of HTML into gophermap, gph and txt. It's common to see files with these formats in Gopherspace.

In particular, I'd like to manually modify the home page and the index page for blog posts.

## Project lueur

This project is called lueur, pronounced `\lɥœʁ\`, which is a French word for vivid, momentary expression.

### How it works

The way the project works is deliberately very simple: I retrieve the text in Markdown format, which can contain HTML. The text is then passed to the Markdown parser, which returns an AST that is traversed to produce the final output. The [goldmark](https://github.com/yuin/goldmark) project was used to parse the Markdown and the [Go Networking](https://cs.opensource.google/go/x/net/+/master:html/) project for the HTML.

### Contributing

The project is under construction. Anyone is free to contribute to the source code. For more details, please visit the [GitHub repository](https://github.com/theobori/lueur).

## Rewriting my files

I automated the rewriting of my files with the lueur project, it helped me transform my blog posts from Markdown format to gph format.

However, I wrote the home page, i.e. the `index.gph` file, and the `posts.gph` file by hand. Here's what these two pages look like on my website through the Gopher client [Gophie](https://gophie.org/). Below is the home page.

<center>
<img src="/my-gph-homepage.png" class="img-center">
</center>

And below the blog posts index.

<center>
<img src="/my-gph-posts.png" class="img-center">
</center>

## Why use Gopher

One might ask why use Gopher in 2026, whether to write a phlog, art, intimde diary or anything else. In my opinion, the author of [baud.baby](gopher://baud.baby) explains it perfectly in this [post](gopher://baud.baby:70/0/phlog/fs20170616.txt). As he says, for older people it may be nostalgia for old technologies, others like the simplicity of the protocol and file format.

I also think that people like to be able to express themselves in a secret place, away from the general public.

## Why I use Gopher

I like the fact that it's a remote corner of the Internet that's hard to get to. I think it makes the experience interesting. It's rare for someone to stumble across a Gopher website by chance; you have to be curious and often passionate.

The community aspect appeals to me, in fact most of the Gopher servers currently running are managed by pubnixes, and my files are themselves behind the [tilde.pink](https://tilde.pink) server.

I also like the fact that Gopher websites are only consumed by humans, because the companies that scrap the content of websites aren't really interested in this protocol. It's too little used and it wouldn't be profitable for them.

The Gopher protocol and the documents it carries are very light. I find it more interesting to concentrate on content rather than form, unlike most modern HTML pages which are highly stylized and carry a lot of elements for the web browser to load. For my personal website, I want this workload to be very low.

I like this simplicity.

## End of my gemtext files maintenance

I also really like the [Gemini](https://geminiprotocol.net/) protocol, but I'd rather concentrate exclusively on Gopher, so I've deleted my old gemtext files and will only be maintaining my gph files. I will still continue to consume content through Gemini but for the time being I won't be producing any more.

## Conclusion

I love Gopher and its ecosystem more than ever, and I intend to keep my little part of Gopherspace up to date.
