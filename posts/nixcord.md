---
title: Declarative Vencord configuration on NixOS
date: "2024-11-01"
---

After installing [Vesktop](https://github.com/Vencord/Vesktop) in the classic way on NixOS, i.e. by installing the `vesktop` package in the official Nix expressions collection. I wondered if there wasn't a cleaner way of configuring the application. Because configuring an application on every new system is a pain.

So I found [Nixcord](https://github.com/KaylorBen/nixcord). It is a [home-manager](https://nix-community.github.io/home-manager) module that allows you to declare [Vencord](https://vencord.dev) parameters and plugins in Nix.

It's pretty simple to use and works perfectly. Just add it to the home-manager's imported modules and activate it.

I've written my own Nix module that wraps nixcord, so here's what it looks like.

```nix
{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf types strings;
  inherit (lib.${namespace})
    mkBoolOpt
    mkOpt
    enabled
    disabled
    ;

  cfg = config.${namespace}.messages.discord;

  trimWith' =
    s:
    strings.trimWith {
      start = true;
      end = true;
    } s;
in
{
  options.${namespace}.messages.discord = with types; {
    enable = mkBoolOpt false "Whether or not to manage discord.";
    quickCss = mkOpt str (builtins.readFile ./custom.css) "Vencord quick CSS.";
    config = mkOpt attrs {
      useQuickCss = ((trimWith' cfg.quickCss) != "");
      plugins = {
        betterFolders = enabled;
        betterRoleContext = enabled;
        crashHandler = enabled;
        memberCount = enabled;
        mentionAvatars = enabled;
        messageLatency = enabled;
        showHiddenThings = enabled;
        showMeYourName = enabled;
        webContextMenus = enabled;
        webKeybinds = enabled;
        webScreenShareFixes = enabled;
        alwaysAnimate = enabled;
      };
    } "Manage the nixcord configuration.";
  };

  config = mkIf cfg.enable {
    stylix.targets.vesktop.enable = false;

    programs.nixcord = {
      enable = true;
      discord = disabled;
      vesktop.enable = true;

      inherit (cfg) config quickCss;
    };
  };
}
```

With regard to the above code snippet, please note that in my case, the home-manager modules are managed by the [Snowfall lib](https://snowfall.org/guides/lib/quickstart) .

```nix
enabled = { enable = true; };
disabled = { enable = false; };
```

I've explicitly deactivated de Discord which is enabled by default, as well as the Vesktop theming by [Stylix](https://stylix.danth.me) because the [Dracula](https://draculatheme.com) theme (far too cyan-based).

Instead I downloaded [draculatheme.com/betterdiscord](https://draculatheme.com/betterdiscord) so as not to depend on the Internet and activated it with the `quickCss` option.

[Nixcord](https://github.com/KaylorBen/nixcord) is really great, you really should use it !
