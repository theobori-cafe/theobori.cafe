---
title: My eBPF exploration
date: "2024-01-11"
---

<style nonce="Fg4i6piWbxQWdgGv66UX1V1B5zwNWL4Om8vSTS4QG4I">
  .img-center-w400px {
    max-width: 100%;
    width: 400px;
  }
</style>

<center>
    <img src="/ebpf.png" class="img-center-w400px">
</center>


Having discovered eBPF and read a few books about it, I'm writing here the essentials to remember about the basics. It's mainly a mix of my personal notes from the books "Learning eBPF" by Liz Rice and "Linux Observability with BPF" by David Calavera. The aim is to write down the essentials without going into too much technical detail, a sort of memo.

You can find my eBPF (XDP) projects at the bottom of the page.


## What is eBPF ?

eBPF stands for extended Berkeley Packet Filter. It's a virtual machine with a minimalist instructions set in the kernel (Linux) that lets you run BPF programs from user space. These BPF programs are attached to objects in the kernel and executed when these objects are triggered by events.



<center>
    <img src="/basic_ebpf_scheme.png" class="img-center">
</center>


eBPF mainly avoid use to rewrite the kernel source code and the whole process (even after writing code, waiting for changes can take years. It allows the kernel to be dymanic.

Linux modules exist, they can be loaded dynamically, but there is a problem, the safety/security is too long to check, and it is too risky. eBPF has fixed this problem with the eBPF verifier.


### Important features

[Kernel probe](https://docs.kernel.org/trace/kprobes.html) is an important part of the eBPF functioning.
> *"It enables you to dynamically break into any kernel routine and collect debugging and performance information non-disruptively."*


So how can a user (user space) communicate with a BPF program (kernel space) ?

It is possible thanks to BPF maps. A map is a key/value stores that resides in the kernel and that can be accessed from eBPF program and from the user space via bpf syscalls.


## eBPF program

An eBPF program is nothing else than a set of eBPF instructions in a bytecode format. eBPF uses JIT compiler to convert the eBPF bytecode to machine code that run natively on the CPU.



<center>
    <img src="/ebpf_build_chain.png" class="img-center">
</center>


eBPF program take a pointer to a context that depends of the type of event (defining different type of program help the verifier).

There are a set of functions that eBPF programs can call, it is called bpf helper functions.

Each program type cannot call every bpf helper functions, some are banned by the verifier. As example, an XDP program cannot use `bpf_get_current_pid_tgid.` A program type has its own return code meanings.

[BPF Kernel functions](https://docs.kernel.org/bpf/kfuncs.html) aka kfuncs allow internal kernel functions to be called from eBPF programs.


## BPF System call

This system call allow us to perform a command on an extended BPF map or program.

```c
#include <linux/bpf.h>

int bpf(int cmd, union bpf_attr *attr, unsigned int size);
```


An example of the bpf system call output from `strace`.

```text
bpf(BPF_BTF_LOAD, ...) = 3
bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_PERF_EVENT_ARRAY…) = 4
bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_HASH...) = 5
bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_KPROBE,...prog_name="hello",...) = 6
bpf(BPF_MAP_UPDATE_ELEM, ...}
...
```


## BTF

BTF stands for BPF Type Format, it is the metadata format which encodes the debug information associated with eBPF programs/map.

> *"BTF provides a standardized way to describe the data structures used by eBPF programs, enabling better interaction between user-space tools and the kernel."*

The BTF is stored as a BPF map after the BPF program is loaded. It makes the BPF programs portable across different kernel versions.


## CO-RE

CO-RE stands for Compile Once, Run Everywhere, the idea behing is to compile a program once and run it on different kernel version without recompiling it.

We can list some CO-RE elements:
- BTF
- Kernel headers
  - Including individual header files
  - Generating kernel headers (vmlinux.h) with `bpftool`
- Compiler support flags like `-g`
- Data structure relocations support for libraries
  - Information relocation based on destination machine data structure difference, it is used to compensates
- BPF skeleton
  - Generated with `bpftool`, it allows the programmer to call functions to manage the BPF program lifecycle


## eBPF verifier

The verification process ensures the eBPF bytecode is safe.

It tests every possible execution paths, it pushes copy of the regs onto a stack and explore one of the possible paths.

It is optimized to avoid evaluating the instructions with something called state pruning, it avoids reevaluating path (record registers state and if it arrives on the same instruction with a matching state, there is no need to verify the rest of path).


## XDP

XDP stands for eXpress Data Path, it is a programmable kernel-integrated packet processor in the Linux network data path that execute BPF programs.

> *"The packet processor is the in-kernel component for XDP programs that processes packets on the receive (RX) queue directly as they are presented by the NIC.*"

XDP programs can make decision (drop, pass, etc..) on the received packets.


## Important Linux concepts

The capabilities are a way of dividing Linux root privileged into smaller "units".

Seccomp means Secure Computing and is a security layer in Linux that allow to filter specific syscalls.



## Links

Here are some of my XDP projects.



[https://github.com/theobori/tinyknock](https://github.com/theobori/tinyknock)
[https://github.com/theobori/tinyfilter](https://github.com/theobori/tinyfilter)


