---
title: Yet another Lox interpreter
date: "2024-03-22"
---

I wanted to learn more about designing an interpreter, so I looked around and found the free "Crafting Interpreters" by Robert Nystrom.

I read parts I and II, which focus on concepts, common techniques and language behavior. Since I have recently read these parts, writing helps me to better understand and even re-understand certain things.
  
For the moment I'm not quite done, I've implemented the features below.

- *Tokens and lexing*
- *Abstract syntax trees*
- *Recursive descent parsing*
- *Prefix and infix expressions*
- *Runtime representation of objects*
- *Interpreting code using the Visitor pattern*
- *Lexical scope*
- *Environment chains for storing variables*
- *Control flow*
- *Functions with parameters*
- *Closures*
- *Static variable resolution and error detection*
&nbsp;

## What is lox ?

To sum up [this page](https://craftinginterpreters.com/the-lox-language.html), Lox is a small, high-level scripting language, with dynamic types and automatic memory management. It is similar to Javascript, Lua and Scheme.

A cool fact is that Lox is Turing complete, it means it is able to run a Turing machine.
&nbsp;

## Essentials basics

I've learned some important key concepts, and here are a few of the most important.

&nbsp;

<center>
    <img src="/mountain_lang.png" class="img-center">
</center>

&nbsp;

### Scanning

Scanning is also known as lexing or lexical analysis. It takes a linear stream of characters and chunks them into tokens (words).

The scanner must group characters into the smalles possible sequence that represents something. This blobs of characters are called lexemes.

Here are some examples of token kinds.

```python
...
from enum import Enum
...

class TokenKind(Enum):
    """
        Represents every available token kinds
    """

    # Single-character tokens
    LEFT_PAREN = "left_paren",
    RIGHT_PAREN = "right_paren",
    LEFT_BRACE = "left_brace",
    RIGHT_BRACE = "right_brace",
    ...

    # One or two character tokens
    BANG = "bang",
    BANG_EQUAL = "bang_equal",
    EQUAL = "equal",
    ...
        
    # Literals
    IDENTIFIER = "identifier",
    STRING = "string",
    NUMBER = "number",
    
    # Keywords
    AND = "and",
    CLASS = "class",
    ELSE = "else",
    FALSE = "false",
    ...
    
    EOF = "eof"
```
&nbsp;

### Parsing

It takes the flat sequence of tokens and builds a tree structure that represent the nested nature of the grammar. This three is called an Abstract Syntax Tree (AST)

The Lox interpreter I made is a Tree-Walk Interpreter, it means it traverses the AST one branch and leaf at a time and it evaluates.

&nbsp;

### Context-Free Grammars

It is a formal grammar, it allows us to define an infinite set of rules that are in the grammar, it specicies which strings are valid and which are not.

&nbsp;

### Rules for grammars

We use rules to generate strings that are in the grammar, it is called derivation, each is derived from an existing rule on the grammar.

> *The rules are called productions because they produce strings in the grammar*

Each production has a head (its name) and a body (a list of symbols).

A symbol can be:
- A terminal, it is like an endpoint, it simply produces it.
- A non-terminal, it refers to other rule in the grammar.

&nbsp;

A grammar example from the book, see below.

```python
breakfast → protein ( "with" breakfast "on the side" )?
          | bread ;

protein → "really"+ "crispy" "bacon"
        | "sausage"
        | ( "scrambled" | "poached" | "fried" ) "eggs" ;

bread → "toast" | "biscuits" | "English muffin" ;
```

The ponctuations is based on the regex behaviors, as example, the `?` means it is optional.
&nbsp;

So here, a valid strings could be the one below.

```python
"poached" "eggs" "with" "toast" "on the side"
```

&nbsp;

### Recursive Descent Parsing

The best explanation here is probably the one in the book.

> *Recursive descent is considered a top-down parser because it starts from the top or outermost grammar rule (here expression ) and works its way down into the nested subexpressions before finally reaching the leaves of the syntax tree.*


&nbsp;

## Links

[https://github.com/theobori/tinylox](https://github.com/theobori/tinylox)

&nbsp;
