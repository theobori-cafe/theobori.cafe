---
title: OpenSSH port knocking with UFW on Debian
date: "2023-10-10"
---

<center>
    <img src="/openssh.png">
</center>
&nbsp;

There are quite a few known methods for securing an **OpenSSH** server that you should already be familiar with, such as disabling remote root access, disabling password login or changing the port (22 by default).
&nbsp;
Another highly effective method applicable to SSH ports is port knocking. 
&nbsp;
Port knocking is a method of opening ports on a machine by making a series of connections to closed ports. The firewall will then react accordingly.
&nbsp;
This is very useful, as it allows you to keep your SSH port closed, so it won't show up on port scans (nmap or other).
&nbsp;
This can be done directly by configuring `iptables`, but I've opted to use `ufw` coupled with `knockd`.
&nbsp;

## How does it work ?

`knockd` is the port-knock server that will run on the target machine as a daemon. It is going to handle the connection on the specified ports in the configuration.
&nbsp;
`ufw`, our netfilter firewall program, will be called by `knockd` and in ou case edit `iptables` rules.
&nbsp;

## Installation

So first, install the packages for both of them
```bash
apt install ufw knockd
```
&nbsp;

## Configuration

Now, let's see how to configure this tools. I assume that you are using Systemd.

&nbsp;

### ufw

The default `ufw` configuration is enough to perform port knocking, it should be as the following. `ufw` has to be enabled to show its default policies.

```bash
ufw enable
ufw status verbose | grep Default
```
&nbsp;

Output

```bash
Default: deny (incoming), allow (outgoing), deny (routed)
```
&nbsp;

If it is not the case, you can change the default policies.

```bash
ufw default allow incoming
ufw default deny outgoing
```
&nbsp;

Once it is done, you can reload the `ufw` configuration to make sure the modifications take effect immediatly.

```bash
ufw reload
```
&nbsp;

### knockd

First of all, make sure that you are using the network interface you want.
&nbsp;
In `/etc/default/knockd`, you can edit the `knockd` options that will be used with the executed command by the Systemd service.

```ini
...
# command line options
KNOCKD_OPTS="-i eth0"
```
&nbsp;

Now we describe how will `knockd` act by editing `/etc/knockd.conf`.

Here is an example of what could be done, in this example our SSH port is `47612`.

```ini
[options]
    UseSyslog

[openSSH]
    sequence = 7264,3981,5410
    seq_timeout = 5
    start_command = ufw allow from %IP% to any port 47612

[tmpOpenSSH]
    sequence = 8792,6137,2058
    seq_timeout = 5
    start_command = ufw allow from %IP% to any port 47612
    tcpflags = syn
    cmd_timeout = 10
    stop_command = ufw delete allow from %IP% to any port 47612

[closeSSH]
    sequence = 4496,1625,7349
    seq_timeout = 5
    start_command = ufw delete allow from %IP% to any port 47612
```
&nbsp;

In this configuration are described three `knockd` knocks.
&nbsp;
**`openSSH`** will add a new `ufw` rule to allow the client IP address on the port 47612 after the received TCP sequence `7264,3981,5410`.

**`tmpOpenSSH`** will add a `ufw` rule that allowed the client IP address on the port 47612 after the received TCP sequence `8792,6137,2058`. This rule is going to timeout and then be removed after 10 seconds

**`closeSSH`** will remove a `ufw` rule that allowed the client IP address on the port 47612 after the received TCP sequence `4496,1625,7349`.

&nbsp;

You can finally start the port-knock server.

```bash
systemctl restart knockd
```
&nbsp;

## Usage

Now everything is setup, you can use the port-knock client `knock` (from the package `knockd`) to perform TCP connections on your target machine.
&nbsp;
As example:
```bash
knock -v localhost 7264 3981 5410
```
