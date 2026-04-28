---
title: Esoteric programming languages
date: "2026-04-28"
---

## Introduction

A while back, I became interested in esoteric programming languages. More specifically, I became interested in the mechanisms involved in interpreting and compiling their code. It’s a little-known field in the world of computer science, yet I find this culture to be very rich and challenging. That’s why I wanted to talk about it here, in the form of a blog post. This is mainly my personal perspective and feedback; the views expressed are my own.

## Definition

An esoteric programming language is a programming language designed around one or more strange or unusual ideas. Generally, these languages are created as a joke or to meet a challenge, and are not intended to solve any specific problem.

### Example

One of the best-known languages is [Brainfuck](https://esolangs.org/wiki/Brainfuck).

```text
[xmastree.b -- print Christmas tree
(c) 2016 Daniel B. Cristofani
http://brainfuck.org/]

>>>--------<,[<[>++++++++++<-]>>[<------>>-<+],]++>>++<--[<++[+>]>+<<+++<]<
<[>>+[[>>+<<-]<<]>>>>[[<<+>.>-]>>]<.<<<+<<-]>>[<.>--]>.>>.
```

Below is a code example from one of my favorite programming languages, [Befunge](https://esolangs.org/wiki/Befunge).

```text
vv  <      <
    2
    ^  v<
 v1<?>3v4
    ^   ^
>  >?>  ?>5^
    v   v
 v9<?>7v6
    v  v<
    8
    >  >   ^
 vv  <      <
     2
     ^  v<
  v1<?>3v4
     ^   ^
 >  >?>  ?>5^
     v   v      v          ,*25         <<
  v9<?>7v6                              ,,
     v  v<                              ""
     8                                  ><
     >  >   ^                           ""v
  >*: >0"!rebmun tupnI">:#,_$25*,:&:99p`|^<       _0"!niw uoY">:#,_$25*,@
      ^         <                       >:99g01-*+^
```

I invite you to run the code examples below if you'd like.

## Culture and Community

There are a vast number of esoteric programming languages, and new ones are created every day, often accompanied by an interpreter written by the language’s creator.

### Esolang

We are fortunate to have the [Esolang](https://esolangs.org/) website. It is a wiki dedicated to esoteric programming languages, an excellent resource for their documentation, and one of the main hubs of this active community. The website allows authors to add wiki pages to document their languages. These pages are then indexed on other pages dedicated to listing languages by category, paradigm, year, etc.

I have used this website extensively as my primary reference for esoteric language specifications. The website is comprehensive and updated daily.

### Challenge

Since most of these languages started out as jokes, they are actually used to create more unusual challenges. As shown in this [code golf](https://codegolf.stackexchange.com/questions/84/interpret-brainfuck) where you have to create a Brainfuck interpreter, this [YouTube video](https://www.youtube.com/watch?v=NFsu2E-45e0), or the game [Brainfuck Challenge](https://store.steampowered.com/app/3708560/Brainfuck_Challenge). This inspired me to create [this project](https://github.com/theobori/eso), which brings together my implementations of interpreters and compilers for esoteric programming languages.

### Passion and Curiosity

One might wonder why people continue to invent new esoteric languages, since there is no financial gain to be had. I think the main reasons are passion and curiosity. A passion for computer science and programming, and the curiosity to seek out alternative things on the Internet.

## Humans Only

Despite all the hype surrounding generative AI, I get the impression that esoteric languages remain a field studied largely by human minds alone. This can be explained by the lack of commercial objectives; after all, the authors and developers of these languages aren’t getting paid. Furthermore, it’s a subject that doesn’t interest companies because they can’t make a profit from it, and it’s not a topic that comes up in business settings either. It’s not a mainstream computer science subject, and demand is very low. In the end, only enthusiasts and the curious remain—those who simply want to have fun.

An esoteric programming language that isn’t a product of the human mind loses all its charm and appeal. These languages are complex for the human brain, but much less so for an artificial brain, such as an LLM.

## Conclusion

It was an interesting experience to explore the world of esoteric programming languages. I realized there is an active community and a large number of software projects. I didn’t delve any deeper—some languages are very complex—but if you’re curious, I invite you to check out the [Esolang](https://esolangs.org/) wiki.

I plan to continue implementing interpreters and compilers for esoteric languages in the future!
