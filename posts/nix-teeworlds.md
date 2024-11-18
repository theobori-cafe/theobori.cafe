---
title: My NixOS Teeworlds servers management module
date: "2024-11-10"
---

So I created a NixOS module to declare Teeworlds servers with their Nix configuration.

Why did I do this? Simply because I saw a [video](https://www.youtube.com/watch?v=Fph7SMldxpI) from [Vimjoyer](https://www.youtube.com/@vimjoyer) that presented a NixOs module for declaring multiple Minecraft servers. I couldn't find an equivalent for Teeworlds, so I decided to write it myself.

The module is open-source and available via a [GitHub repository](https://github.com/theobori/nix-teeworlds). In this repository there are also some packages providing a server with particular game modes, which are obviously usable with the module.

They can also be run with the `nix run` command, for example, you could create an [fng2](https://github.com/Jupeyy/teeworlds-fng2-mod/tree/fng_06) server with the following command.

```bash
nix run github:theobori/nix-teeworlds#fng2-server
```
&nbsp;

The module is user-friendly and fairly intuitive to configure. For example, to configure a [fng2](https://github.com/Jupeyy/teeworlds-fng2-mod/tree/fng_06) server, you could write a Nix expression like this.

```nix
{ pkgs, ... }:
{
  services.nix-teeworlds = {
    enable = true;
    openFirewall = true;

    servers = {
      my-fng = {
        enable = true;
        package = pkgs.fng2-server;

        extraConfig = ''
          password "1234"
        '';

        externalConsole = {
          enable = true;
          port = 1111;
          password = "hello";
          outputLevel = 2;
        };

        settings = {
          name = "My FNG server from NixOS";
          port = 8305;
          maxClients = 16;
        };

        game = {
          gameType = "fng2";
          map = "AliveFNG";
          scoreLimit = 800;
        };

        votes = {
          "Say hello" = {
            commands = [
              "say hello"
              "say world"
              "say !!"
            ];
          };

          "Map IIT_Edited" = {
            commands = [ "sv_map IIT_Edited" ];
          };

          "Empty vote" = {
            commands = [ ];
          };
        };
      };
    };
  };
}
```
&nbsp;

To access `services.nix-teeworlds`, you can import the module as specified in the README file in the [GitHub repository](https://github.com/theobori/nix-teeworlds).

Inside your `flake.nix`, you can start by adding the following lines.

```nix
{
  inputs = {
    nix-teeworlds.url = "github:theobori/nix-teeworlds";
  };
}
```
&nbsp;

You can then include the module and its default overlay in the system configuration as shown below.

```nix
{ inputs, ... }: {
  imports = with inputs; [ nix-teeworlds.nixosModules.nix-teeworlds ];
  nixpkgs.overlays = with inputs; [ nix-teeworlds.overlays.default ];
}
```
&nbsp;

Under the hood, each teeworlds server is managed by a systemd service unit, which takes care of running the application with a dedicated user in the right working directory and creating the necessary resources.

Evaluation of the module may return an error if the ports of the different servers (TCP and UDP) are identical, as written [in the code](https://github.com/theobori/nix-teeworlds/blob/main/modules/nixos/nix-teeworlds/default.nix#L138-L143).

Anyone is free to contribute to the source code. For more details, please visit the [GitHub repository](https://github.com/theobori/nix-teeworlds).