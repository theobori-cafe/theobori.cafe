---
title: My bytecode VM Lox interpreter
date: "2024-10-06"
---

The aim of this post is to describe the general operation of the program and some of the mechanisms that we consider to be of interest. For full details, a link to the source code is available at the bottom of the page.

So I continued with “Crafting Interpreters” by Robert Nystrom after making [My Tree-Walker Lox interpreter](/posts/jlox). In this part I tried to do as many challenges as possible and really understand how a VM bytecode works.

This version is written in C, which means we have to write a lot of code ourselves, but we don't use any external libraries.

## Compiler

The primary purpose of our compiler is to generate a chunk of code in bytecode form for interpretation by our bytecode virtual machine. Here are a few interesting features of the front end.

### Scanner

The token scanner is very classic, with only one thing to say: the function responsible for identifying the language's native keywords is very dirty. The author has chosen to use a large switch statement instead of implementing a sorting function, which is certainly powerful but not very elegant.

### Parser

An interesting point to note is that the author chose not to use a syntax tree for the front end. We therefore implemented a single-pass compiler (directly converts compile units into bytecode).

We also implemented a Vaughan Pratt's parser, in our case a “top-down operator precedence parser”. This means we have to define operator precedence in advance. Here's what it looks like in code.

```c
typedef enum {
  PREC_NONE,
  PREC_ASSIGNMENT, // =
  PREC_OR,         // or
  PREC_AND,        // and
  PREC_EQUALITY,   // == !=
  PREC_COMPARISON, // < > <= >=
  PREC_TERM,       // + -
  PREC_FACTOR,     // * /
  PREC_UNARY,      // ! -
  PREC_CALL,       // . ()
  PREC_PRIMARY
} Precedence;
```

This precedence is simply used to control the parsing of expressions. A rule with a lower precedence than the last parsed expression is not allowed.

## Bytecode

To manage conditions, we emit `OP_JUMP` operation code for conditions. If a condition expression is evaluated to false, it jumps to the end of the conditionnal block / expression. To do this, we use the concept of backpatching: we overwrite the immediate value of the instruction in the chunk during compilation.

In my implementation, all immediate values are encoded on 8 bits, with the exception of constants, which have a size of 24 bits.

## Virtual Machine

The VM is centered on a stack where we push operands, local variables, etc..

Everything at runtime is managed by callframes, even the top-level code is embed within a function object.

## Example

Here is a simple Lox example that can be evaluated by my interpreter.

```text
fun fib(n) {
    if (n < 2) {
        return n;
    }

    return fib(n - 2) + fib(n - 1);
}

print fib(10);
```

## Links

[https://github.com/theobori/lox-virtual-machine](https://github.com/theobori/lox-virtual-machine)


