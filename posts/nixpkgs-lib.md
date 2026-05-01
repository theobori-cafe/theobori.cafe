---
title: Nix functions in pure Python
date: "2026-04-30"
---

## Introduction

I often come up with new ideas for computer projects when I’m bored and browsing the internet. One day, I had the idea to port the library component of nixpkgs to pure Python. I simply wanted to be able to use functions in nixpkgs from within Python. It’s a pretty old project, but I still think it’s cool, which is why I wanted to talk about it in this short blog post.

## My goal

The main goal of this project is to keep myself busy. I’ve always thought the `lib.fixedPoints.fix` nixpkgs function was cool, so I wanted to at least be able to use that function in Python.

Just to clarify, my goal isn’t to call [NixCpp](https://github.com/NixOS/nix) functions from Python, there is already the [python-nix](https://github.com/tweag/python-nix) project for that. I want to rewrite the logic of Nix functions in pure Python, with no dependencies other than the Python interpreter.

## Nixpkgs

I’ve mentioned nixpkgs several times before, but what exactly is it? It’s a [GitHub repository](https://github.com/NixOS/nixpkgs) for NixOS that contains the official collection of Nix and NixOS expressions. These expressions include Nix packages, NixOS modules, functions, and more.

### Library section

The part of nixpkgs that I want to implement in Python is the [library section](https://github.com/NixOS/nixpkgs/tree/master/lib); some functions cannot be implemented because they depend on [NixCpp](https://github.com/NixOS/nix).

## Laziness bypass

The Nix interpreter has a somewhat special way of evaluating expressions; it uses what is known as lazy evaluation. This means expressions are only evaluated when the interpreter needs their value. The [Python interpreter](https://github.com/python/cpython) does not have this property, and certain functions in the lib section of nixpkgs require laziness, notably the `lib.fixedPoints.fix` nixpkgs function. That is why I had to find a solution to simulate a form of laziness.

### Fix function

This is a function in nixpkgs that allows you to find the fixed point of a function. This function relies entirely on the lazy property of the Nix interpreter. Below is its definition in Nix.

```nix
fix =
  f:
  let
	x = f x;
  in
  x;
```

Below are a few examples of how to call the function.

```text
nix-repl> lib.fix (self: {a = 1; b = self.a + 1})
{
  a = 1;
  b = 2;
}

nix-repl> lib.fix (self: [1 ((lib.elemAt self 0) + 1)])
[
  1
  2
]

nix-repl> lib.fix (lib.fix (f: self: {a = 1; b = self.a + 1;}))
{
  a = 1;
  b = 2;
}
```

And here is my Python implementation.

```python
def fix(f: Callable) -> Any:
    """Compute the least fixed point of a function"""

    # Evaluates with the stub value
    result = f(StubSequence())
    # Final evaluation
    result = f(result)

    return result
```

### Little hack

The hack involves evaluating the function `f`, passed as an argument, once by passing it a class that returns default values for its special Python methods. This way, we can retrieve the default values needed for the final evaluation.

### Example

For example, let’s take the following Python function.

```python
g = lambda self: {"a": 1, "b": self["a"] + 1}
```

You can imagine that this will produce something like this in the `fix` function.

```python
# fix(g)
result = f(StubSequence())
result = f({"a": 1, "b": 0 + 1})
result = {"a": 1, "b": 2}
```

Ca fonctionne aussi avec des listes et des fonctions, comme par exemple ci-dessous.

```python
fix(lambda self: [1, 2, 3, self[0] + self[1])
fix(fix(lambda x: lambda f: [1, 2, 3, f[0] + f[1]))
```
### Technical limitation

Since this approach isn’t true laziness, it obviously has a limitation. It doesn’t allow for correctly resolving chains with a depth greater than one. That is, in a list or dictionary, a variable cannot depend on more than one other variable. I think it’s technically possible to work around this problem, for example by keeping track of dependency chains in a graph; if you’re interested, you can try implementing it in [the project](https://github.com/theobori/nixpkgs-lib).

## Function calling style

Technically, all functions with more than one argument are curried, so they must be called as follows.

```python
find_single(lambda x: x == 3)("none")("multiple")([1, 9])
```

But in this module, the functions, although curried, can be called in any way.

```python
# A more comfortable calling style, still returning a function that return a function
first_part = find_single(lambda x: x == 3, "none")
# More explicit calling style
first_part("multiple")([1, 9])
```

## Progress

I've implemented a number of the features I wanted—55.93% to be exact. Detailed progress is available in the [project documentation](https://github.com/theobori/nixpkgs-lib/tree/main/README.md). This progress report is generated using [a script](https://github.com/theobori/nixpkgs-lib/blob/main/nixpkgs_lib/scripts/statistics.py) that I wrote in Python.

## Conclusion

It’s a pretty fun and laid-back project that helps me pass the time sometimes. The only downside is certain differences between Python and Nix, such as Nix’s lazy evaluation, which can make porting to Python complicated.
