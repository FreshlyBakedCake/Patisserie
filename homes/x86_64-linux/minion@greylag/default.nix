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
  home.file.".snowfall.systemname".text = ''
    greylag
  '';

  programs.gpg.scdaemonSettings = {
    reader-port = "Yubico Yubi";
  };

  programs.git.extraConfig.alias = {
    recommit = "!git commit --verbose -eF $(git rev-parse --git-dir)/COMMIT_EDITMSG";
  	graph = "log --graph --oneline --decorate";
  	hash = "rev-parse HEAD";
  	personal = "config user.email skyler3665@gmail.com";
	  clicks = "config user.email minion@clicks.codes";
	  collabora = "config user.email skyler.grey@collabora.com";
  };

  programs.git.extraConfig.user = {
    name = "Skyler Grey";
    signingkey = "7C868112B5390C5C";
  };

  chimera = {
    hyprland.enable = true;
    hyprland.hyprpaper.splash.enable = true;

    touchpad.enable = true;

    hyprland.monitors = [
      "eDP-1,preferred,0x0,1"
      "desc:Dell Inc. DELL P2715Q V7WP95AV914L,preferred,2256x-1956,1,transform,1"
      "desc:AOC 2460G5 0x00023C3F,preferred,336x-1080,1"
    ];

    theme.wallpaper = ./wallpaper.png;
    theme.catppuccin = {
      enable = true;
      style = "Latte";
      color = "Maroon";
    };

    browser.chromium = {
      enable = true;
      extensions = {
        ublockOrigin.enable = true;
        bitwarden.enable = true;
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
      extraExtensions = [ config.nur.repos.rycee.firefox-addons.sidebery ];
    };

    shell.bash.enable = true;
    shell.defaultAliases.enable = true;

    theme.font.nerdFontGlyphs.enable = true;

    editor.ed = {
      enable = true;
      prompt = ":";
      defaultEditor = false;
    };

    editor.neovim.enable = true;

    editor.emacs = {
      enable = true;
      defaultEditor = false;
    };

    input.keyboard = {
      layout = "us";
      variant = "dvorak";
    };

    input.mouse.scrolling.natural = true;

    git = {
      delta.enable = true;
      stgit.enable = true;
      gitReview.enable = true;
      gitCrypt.enable = true;
      auth.clicksUsername = "minion";
      gpg.enable = true;
    };
  };
}
