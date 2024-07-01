{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.chimera.users.coded;
in {
  options.chimera.users.coded.enable = lib.mkEnableOption "Enable Chimera options for coded";

  config = lib.mkIf cfg.enable {
    # Chimera Config
    chimera.nextcloud.enable = true;

    chimera.shell.rebuildFlakePath = "/home/coded/Programming/Chimera/Nix/NixFiles";

    chimera.shell = {
      zsh.enable = true;
      starship.enable = true;

      defaultAliases.enable = true;
      usefulPackages.enable = true;

      replacements = {
        defaultEnable = true;
        bat.enable = false;
        atuin.enableUpArrow = true;
      };
    };

    chimera.git = {
      delta.enable = true;
      stgit.enable = true;
      gitReview.enable = true;
      auth.clicksUsername = "coded";
      gpg.enable = true;
    };

    chimera.input.touchpad = {
      enable = true;
      scrolling.natural = true;
    };

    chimera.browser.firefox = {
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
      extraExtensions = [
        config.nur.repos.rycee.firefox-addons.refined-github
        config.nur.repos.rycee.firefox-addons.new-tab-override
      ];
    };

    chimera.games.minecraft.enable = true;

    chimera.editor = {
      neovim.enable = true;
      editorconfig.enable = true;
      emacs = {
        enable = true;
        defaultEditor = false;
      };
    };

    chimera.theme.font.nerdFontGlyphs.enable = true;

    chimera.theme.catppuccin = {
      enable = true;
      style = "Macchiato";
      color = "Blue";
    };

    chimera.yubikey.enable = true;

    chimera.niri.startupCommands = [
      {
        command = [ "nextcloud" ];
      }
    ];

    # Programming Folder Creation
    home.file = {
      "Programming/README.md" = {
        text = ''
        # Structure
        [Org]/[Language]/[project]

        Both Org and Language should be capitalized however project may follow any name scheme.
        '';
      };
      "Programming/Personal/README.md" = {
        text = ''
        # What is this directory for?
        This directory stores all my personal programming projects

        # Git config modifications
        user.name = "Samuel Shuert"
        user.email = "me@thecoded.prof"
        '';
      };
      "Programming/Auxolotl/README.md" = {
        text = ''
        # What is this directory for?
        This directory stores all Auxolotl related programming projects

        # Git config modifications
        user.name = "Samuel Shuert"
        user.email = "me@thecoded.prof"
        '';
      };
      "Programming/Chimera/README.md" = {
        text = ''
        # What is this directory for?
        This directory stores all Chimera related programming projects

        # Git config modifications
        user.name = "Samuel Shuert"
        user.email = "me@thecoded.prof"
        '';
      };
      "Programming/Clicks/README.md" = {
        text = ''
        # What is this directory for?
        This directory stores all Clicks related programming projects

        # Git config modifications
        user.name = "Samuel Shuert"
        user.email = "coded@clicks.codes"
        '';
      };
    };

    # Git Config
    programs.git.includes = [
      {
        condition = "gitdir:~/Programming/Chimera/**";

        contents = {
          user.name = "Samuel Shuert";
          user.email = "me@thecoded.prof";
        };
      }
      {
        condition = "gitdir:~/Programming/Clicks/**";

        contents = {
          user.name = "Samuel Shuert";
          user.email = "coded@clicks.codes";
        };
      }
      {
        condition = "gitdir:~/Programming/Personal/**";

        contents = {
          user.name = "Samuel Shuert";
          user.email = "me@thecoded.prof";
        };
      }
      {
        condition = "gitdir:~/Programming/Auxolotl/**";

        contents = {
          user.name = "Samuel Shuert";
          user.email = "me@thecoded.prof";
        };
      }
    ];

    # Additional Kitty Config
    programs.kitty.extraConfig = ''
      map kitty_mod+enter launch --cwd=current --type=window
      map kitty_mod+t     launch --cwd=current --type=tab
    '';

    # Additional Packages
    home.packages = [ pkgs.foliate pkgs.openrgb ];
  };
}
