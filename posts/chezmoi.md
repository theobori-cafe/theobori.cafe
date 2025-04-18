---
title: Manage dotfiles with chezmoi
date: "2024-03-10"
---

To give a bit of context, I had automated the deployment of the configuration of my Linux environment with an Ansible playbook ([repository](https://github.com/theobori/self-config)). This setup is compatible with almost all Linux distributions (probably UNIX too) but I was looking for something lighter and simpler.



I found by chance [chezmoi](https://chezmoi.io) which is able to manage dotfiles as well as some other configurations which could be linked to these dotfiles. The tool allows you to update files on several different machines, it's very complete, simple and effective.

Some people pair it with Ansible but I prefer to use the solution in a very simple way, with the tool's native features (scripting and templating).



Something interesting about [chezmoi](https://chezmoi.io) is that it supports file encryption with modern tools like [age](https://age-encryption.org). This is very useful for certain sensitive data such as SSH private keys. So you can add configuration so that the tool can encrypt and decrypt.

My configuration template looks like this (below) in the `.chezmoi.yaml.tmpl` file.



{% raw %}
```jinja2
{{ $has_age := false }}
{{ $sudo := "sudo" }}
{{ $font := "Comic Code" }}

{{ if stdinIsATTY }}
{{ $has_age = promptBool "do you have age " }}

{{- $sudo_choices := list "sudo" "doas" -}}
{{- $sudo = promptChoiceOnce . "choice" "choose" $sudo_choices -}}

{{ $font = promptString "font name " }}
{{ end }}

{{ if $has_age }}
encryption: "age"
age:
    identity: "/home/nagi/.config/age/key.txt"
    recipient: "age14m06fd3svs9neg2w97ccw3c8470hckl95qxr6jw8fgm4ex65352q6tun06"
{{ end }}

data:
    sudo: {{ $sudo }}
    font: {{ $font }}
```
{% endraw %}


For the moment the repository is only compatible with Fedora and Arch Linux, however it is easy to implement other distributions.


## Apply from a different machine

To apply my configuration from another machine, simply run the following commands.

```bash
chezmoi init https://github.com/theobori/dotfiles.git
chezmoi apply -v
```



## Links

[https://github.com/theobori/dotfiles](https://github.com/theobori/dotfiles)


