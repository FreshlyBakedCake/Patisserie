{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  # All other arguments come from the home home.
  config,
  ...
}:
{
  programs.git.extraConfig.alias = {
    graph = "log --graph --oneline --decorate";
    hash = "rev-parse HEAD";
  };

  home.shellAliases = {
    I-FUCKING-SAID-PULL = "f(){ git reset --hard origin/\"$@\"; unset -f f; }; f";
    mini = ''echo "you're using the wrong terminal"'';
  };

  programs.git.extraConfig.user = {
    name = "PineaFan";
    email = "ash@pinea.dev";
    signingkey = "8F50789F12AC6E6206EA870CE5E1C2D43B0E4AB3";
  };

  home.packages = [
    pkgs.kate
    pkgs.libsForQt5.kfind
    pkgs.vlc
    pkgs.obs-studio
    pkgs.python312
    pkgs.playerctl
    pkgs.nodePackages.pnpm
  ];

  programs.firefox.profiles.chimera.settings = {
    "browser.startup.homepage" = "https://discord.com/app|https://matrix.clicks.codes";
  };

  chimera = {
    nextcloud.enable = true;

    theme.catppuccin = {
      enable = true;
      style = "Macchiato";
      color = "Mauve";
    };

    browser.chromium = {
      enable = true;
    };

    browser.firefox = {
      enable = true;
      extensions = {
        youtube = {
          sponsorBlock.enable = true;
          returnDislike.enable = true;
          deArrow.enable = true;
        };
        adnauseam.enable = true;
      };
    };

    input.keybinds = {
      alternativeSearch.enable = true;
    };

    # input.mouse.scrolling.speedFactor = 0.45;
    hyprland = {
      hyprpaper.splash.enable = false;
      enable = true;
      monitors = [
        "DP-1,1920x1080@60,-1920x0,1"
        "HDMI-A-1,1920x1080@75,0x0,1"
        "DP-2,1920x1080@60,1920x0,1"
      ];
      window = {
        blur = 12;
        rounding = 16;
      };
      keybinds.extraBinds = [
        {
          meta = "CTRL";
          key = "1";
          function = "exec, ${pkgs.pulseaudio}/bin/pactl set-default-sink $(${pkgs.pamixer}/bin/pamixer --list-sinks | grep \"Monitors\" | awk '{print $1}')";
        }
        {
          meta = "CTRL";
          key = "2";
          function = "exec, ${pkgs.pulseaudio}/bin/pactl set-default-sink $(${pkgs.pamixer}/bin/pamixer --list-sinks | grep \"Razer Kraken V3\" | awk '{print $1}')";
        }
        {
          key = "F1";
          function = "exec, ~/Pictures/Wallpapers/change.sh light";
        }
        {
          key = "F2";
          function = "exec, ~/Pictures/Wallpapers/change.sh dark";
        }
      ];
      startupApplications = [
        "cd ~/Code/keyboard && python main.py"
      ];
    };

    shell = {
      zsh.enable = true;
      # zsh.theme = "crunch";
      starship.enable = true;

      rebuildFlakePath = "/home/pinea/Code/NixFiles";

      defaultAliases.enable = true;
      usefulPackages.enable = true;

      replacements = {
        defaultEnable = true;
        atuin.enableUpArrow = true;
      };
    };

    theme.font.nerdFontGlyphs.enable = true;
    theme.wallpaper = ./wallpaper.png;

    editor.nano = {
      enable = true;
      defaultEditor = false;
    };

    editor.neovim = {
      enable = true;
      defaultEditor = true;
    };

    editor.editorconfig.enable = true;

    input.keyboard = {
      layout = "gb";
    };

    git = {
      delta.enable = true;
      gitReview.enable = true;
      auth.clicksUsername = "pineafan";
      gpg.enable = true;
      stgit.enable = true;
    };

    games = {
      minecraft.enable = true;
      # itch.enable = true;
    };

    yubikey.enable = true;
    yubikey.pam.enable = true;
    yubikey.pam.key = "pinea:ZY1C32oFgQxsKlJEccxdI6rcdC8cZU8gWnBHMRgwb+MVvbRRqdYVHkIlXokscurAi5s/iQ5jnngDXUwG103ajQ==,m9X/BEHiXM1CrXu1u2zvItbd/Qa/tQGAxhIuD2NB2ohwo5d+vODwYl2faUnLhxcJexOWYBHOAzyWwwoeVRQFJw==,es256,+presence";

    waybar.modules.temperature.enable = true;
    waybar.modules.temperature.hwmonPath = "/sys/class/hwmon/hwmon1/temp1_input";
  };

  services.kdeconnect.enable = true;

  programs.zsh = {
    initExtra = ''
      ${pkgs.pridefetch}/bin/pridefetch -f nonbinary -a
    '';
  };
}
