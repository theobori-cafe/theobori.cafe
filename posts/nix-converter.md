---
title: My Nix converter tool
date: "2025-12-16"
---

## Introduction

Last year I wanted to convert my Nix code into YAML and TOML. So I went looking for an all-in-one CLI tool capable of converting a configuration language into Nix and vice-versa. Unfortunately, I couldn't find what I was looking for, so I decided to create my own tool.

## Presentation

The tool is called [nix-converter](https://github.com/theobori/nix-converter). It's a command-line interface written in Go that converts various configuration languages (YAML, TOML, etc.) to Nix and vice versa.

## How it works

Let's assume we have a source language called A and a destination language called B.

First, I use external Go libraries to retrieve a syntactic abstract representing the code of language A. In a second step, I traverse the retrieved tree, which allows me to produce the code for language B in string form. Finally, once the traversal is complete, the final code is written to the process's standard output. Note that conversions are static only, i.e. expressions will not be evaluated, apart from a few exceptions.

The only exception to these steps is the transformation of Nix code into TOML code. Instead of retrieving a string after the tree traverse, I retrieve a Go data structure that is used by a specialized TOML marshaller.

## Examples of transformations

Let's take a simple example with the JSON code below.

```json
{
  "fruits": [
    "Apple",
    "Banana",
    "Orange",
    1,
    2,
    -1
  ],
  "abc": {
    "c": "c",
    "b": "b",
    "a": "a"
  },
  "": 1,
  "123": "",
  "f123": ""
}
```

To convert it into Nix code, you can use the command line below, which also includes parameters for sorting iterators (lists and hash tables) and ignoring double-quotation marks for keys.

```bash
nix-converter -f file.json -l json -unsafe-keys -sort-iterators "all"
```

Once launched, you get the Nix code below.

```nix
{
  "" = 1;
  "123" = "";
  abc = {
    a = "a";
    b = "b";
    c = "c";
  };
  f123 = "";
  fruits = [
    "Apple"
    "Banana"
    "Orange"
    (-1)
    1
    2
  ];
}
```

If we wish, we can convert this Nix code again, for example with the command line below.

```bash
nix-converter -f file.nix -l toml -from-nix
```

Here's how it would look below.

```toml
"" = 1
123 = ""
f123 = ""
fruits = ["Apple", "Banana", "Orange", -1, 1, 2]

[abc]
  a = "a"
  b = "b"
  c = "c"
```

## Testing the tool

If you're curious and just want to test the tool, you can for example use the Nix package with the latest version of the tool in the Nix Flake of the GitHub repository, as below.

```bash
nix run github:theobori/nix-converter -- -help
```

## Contributing

Anyone is free to contribute to the source code. For more details, please visit the [GitHub repository](https://github.com/theobori/nix-converter).

## Conclusion

[nix-converter](https://github.com/theobori/nix-converter) is a simple and useful tool that I enjoy using when I need to convert Nix code.
