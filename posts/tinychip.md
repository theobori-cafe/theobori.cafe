---
title: CHIP-8 emulator
date: "2023-03-08"
---

I wanted to learn the basics of emulator development and emulation in general. So I decided to make a CHIP-8 emulator.

In fact it's a misuse of language to say that it's an "emulator" because CHIP-8 is a language, so we should rather say "interpreter".

## How does it works ?

So, basically there are three main components that make it works. The **CPU**, the **API** and the Core (kernel).
&nbsp;
The **API** polls the keyboard inputs and send them to the **CPU** that put them in the right memory location.
&nbsp;
The **CPU** fetch, decode and execute an instruction from a **ROM** (program or game), it can change the **VRAM** and the **CPU** registers, etc ..
Depending of the **CPU** state, the window draw the **VRAM** throught the **API**.
&nbsp;
There are approximately n instructions executed per second for a frequency of n hz (n is 500 by default). The sound and delay timers are managed with 60hz.

&nbsp;

<p align="center" width="100%">
  <img src="/breakout_320_160.png" width="40%">
  <img src="/space_invaders_320_160.png" width="40%">
</p>

&nbsp;

<p align="center" width="100%">
  <img src="/ibm_logo_640_320.png" width="60%">
</p>

&nbsp;

## Some extra informations

As I said, it supports some quirks for specific instructions, because according to some old documents,`fx55`, `fx65`, `8xy6` and `8xye` dont have the same semantic depending of the machine they were implemeneted on.
&nbsp;
I implemented the 36 instructions + the 4 I was taking before to be compatible with more ROM.

[*Source*](https://github.com/theobori/tinychip)
