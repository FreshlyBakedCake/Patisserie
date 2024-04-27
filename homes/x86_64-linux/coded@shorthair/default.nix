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
  chimera = {
    waybar.modules.temperature.hwmonPath = "/sys/class/hwmon/hwmon4/temp1_input";
    waybar.modules.backlight.enable = true;

    nextcloud.enable = true;

    shell = {
      zsh.enable = true;

      starship.enable = true;

      rebuildFlakePath = "/home/coded/Programming/Chimera/NixFiles";

      defaultAliases.enable = true;
      usefulPackages.enable = true;

      replacements = {
        defaultEnable = true;
        bat.enable = false;
        atuin.enableUpArrow = true;
      };
    };

    git = {
      delta.enable = true;
      stgit.enable = true;
      gitReview.enable = true;
      auth.clicksUsername = "coded";
      gpg.enable = true;
    };

    hyprland = {
      enable = true;

      monitors = [
        "DP-1,1920x1080@165,0x0,1"
        "DP-2,1920x1080@165,1920x0,1"
        "HDMI-A-1,3840x2160@60,0x-2160,1"
      ];
    };

    hyprland.hyprpaper = {
      splash = {
        enable = true;
        offset = -0.6;
      };
    };

    browser.firefox = {
      enable = true;
      extensions = {
        bitwarden.enable = true;
        youtube = {
          sponsorBlock.enable = true;
          returnDislike.enable = true;
          deArrow.enable = true;
        };
        reactDevTools.enable = true;
        adnauseam.enable = true;
      };
      search = {
        enable = true;
        extensions.enable = true;
        bookmarks.enable = true;
        engines = [
          "Kagi"
          "MDN"
          "NixOS Options"
          "NixOS Packages"
          "Home-Manager Options"
          "Noogle"
          "GitHub"
          "Arch Wiki"
          "Gentoo Wiki"
        ];
      };
      extraExtensions = [ config.nur.repos.rycee.firefox-addons.simple-tab-groups ];
    };

    games.minecraft.enable = true;

    editor.neovim.enable = true;
    editor.editorconfig.enable = true;

    theme.font.nerdFontGlyphs.enable = true;
    theme.wallpaper = ./wallpaper.png;
    theme.catppuccin = {
      enable = true;
      style = "Macchiato";
      color = "Blue";
    };

    yubikey.enable = true;
  };


  programs.git.includes = [
  {
    condition = "gitdir:~/programming/Chimera";

    contents = {
      user.name = "Samuel Shuert";
      user.email = "coded@clicks.codes";
    };
  }
  {
    condition = "gitdir:~/programming/Clicks";

    contents = {
      user.name = "Samuel Shuert";
      user.email = "coded@clicks.codes";
    };
  }
  {
    condition = "gitdir:~/programming/Personal";

    contents = {
      user.name = "Samuel Shuert";
      user.email = "coded@coded.codes";
    };
  }
  ];
}
