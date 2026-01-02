---
title: A toy to visualize recursive function calls
date: "2024-06-29"
---

Recently, I did a little project in [Python](https://python.org) to visualise function calls, especially recursive functions.

It takes the form of a [Python](https://python.org) decorator applied to the desired functions. The data structure used is fairly basic, a tree with nodes that have a parent and an indefinite number of children. Each node represents a function call, and the nodes also include the arguments passed to the function when it is called and, optionally, a return value.

To generate a visual and have an overview of all the function calls, I used [Graphviz](https://graphviz.org/) to manage a graph and save it as a file (DOT, SVG, PNG, etc.).

The decorator also supports memoization, which can also be represented on the final visual.

## How is it used?

These are two clear examples of how the decorator is used.

```python
from callviz.core import callviz, set_output_dir

set_output_dir("out")

@callviz(
  _format="png",
  memoization=True,
  open_file=True,
  show_node_result=True,
)
def fib(n: int):
    if n < 2:
        return n

    return fib(n - 2) + fib(n - 1)

@callviz(_format="png", show_link_value=False)
def rev(arr, new):
    if arr == []:
        return new

    return rev(arr[1:], [arr[0]] + new)

fib(5)
rev(list(range(6, 0, -1)), [])
```


<center>
<img src="/callviz_fib.png" class="img-center">
<img src="/callviz_rev.png" class="img-center">
</center>


## Links

[https://github.com/theobori/callviz](https://github.com/theobori/callviz)


