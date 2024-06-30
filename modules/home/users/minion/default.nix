{ inputs, config, lib, pkgs, ... }:
{
  options.chimera.users.minion.enable = lib.mkEnableOption "Enable Chimera options for minion";

  config = lib.mkIf config.chimera.users.minion.enable (let
    git_emails = {
      personal = "sky@a.starrysky.fyi";
      collabora = "skyler.grey@collabora.com";
      transplace = "minion@trans.gg";
      clicks = "minion@clicks.codes";
    };

    git_email_to_include_option = name: email: {
      condition = "gitdir:~/Code/${name}/";
      contents.user.email = email;
    };

    git_email_to_alias_value = email: "config user.email ${email}";
  in {
    chimera.shell.rebuildFlakePath = "/home/${config.home.username}/Code/chimera/config";

    home.packages = [
      pkgs.logseq
    ];

    programs.git.includes =
      lib.mapAttrsToList
        git_email_to_include_option
        git_emails;

    programs.git.extraConfig.alias = {
      recommit = "!git commit --verbose -eF $(git rev-parse --git-dir)/COMMIT_EDITMSG";
      graph = "log --graph --oneline --decorate";
      hash = "rev-parse HEAD";

      stg-clean = ''!for PATCH in $(stg series -PU); do CHANGE_ID=$(git show -s --format="%(trailers:key=Change-Id,valueonly,separator=%x2C )" $(stg id $PATCH)); git log --format="%(trailers:key=Change-Id,valueonly,separator=%x2C )" | grep -qFx "$CHANGE_ID" && stg delete $PATCH; done'';
    } // (builtins.mapAttrs (_name: email: git_email_to_alias_value email) git_emails);

    home.shellAliases = {
      gpg-card-switch = ''for keygrip in $(gpg --with-keygrip --list-secret-keys 76E0B09A741C4089522111E5F27E3E5922772E7A | grep Keygrip | sed "1d" | sed "s/ *Keygrip = //"); do gpg-connect-agent "delete_key $keygrip" /bye > /dev/null; done; gpg --card-status;'';
    };

    programs.git.extraConfig.user = {
      name = "Skyler Grey";
      signingkey = "7C868112B5390C5C";
    };

    chimera.git = {
      delta.enable = true;
      stgit.enable = true;
      jj.enable = true;
      gitReview.enable = true;
      auth.clicksUsername = "minion";
      gpg.enable = true;
    };

    chimera.theme = {
      font.nerdFontGlyphs.enable = true;
      catppuccin = {
        enable = true;
        style = "Latte";
        color = "Maroon";
      };
    };

    chimera.browser.chromium = {
      enable = true;
      extensions = {
        ublockOrigin.enable = true;
        bitwarden.enable = true;
      };
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
          "Docs.rs"
          "Crates.io"
          "Arch Wiki"
          "Gentoo Wiki"
        ];
      };
      extraExtensions = [
        config.nur.repos.rycee.firefox-addons.sidebery
        config.nur.repos.rycee.firefox-addons.gitpod
        config.nur.repos.rycee.firefox-addons.refined-github
      ];
    };
    programs.firefox.profiles.chimera.userChrome = ''
      @import "${inputs.firefox-sidebery-gnome}/userChrome.css";

      #TabsToolbar {
        display: none;
      }
      #sidebar-header {
        display: none;
      }

      /* Hide "Sign in to sync" */
      #PanelUI-fxa-status {
        display: none !important;
      }
      #appMenu-fxa-status2, #appMenu-fxa-separator {
        display: none !important;
      }
    '';
    programs.firefox.profiles.chimera.userContent = ''
      @import "${inputs.firefox-sidebery-gnome}/userContent.css";

      @-moz-document url("about:preferences") {
        #category-sync { display:none!important; }
        #category-more-from-mozilla { display:none!important; }
      }
    '';
    programs.firefox.profiles.chimera.settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "browser.uidensity" = 0;
      "browser.theme.dark-private-windows" = false;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
    };

    chimera.shell = {
      bash.enable = true;
      defaultAliases.enable = true;
      replacements.defaultEnable = true;
      replacements.bat.enable = false;
      replacements.glow.enable = false;
      usefulPackages.enable = true;
    };

    chimera.editor = {
      ed = {
        enable = true;
        prompt = ":";
        defaultEditor = false;
      };

      neovim = {
        enable = true;
        defaultEditor = false;
      };

      emacs.enable = true;

      editorconfig.enable = true;
    };

    chimera.yubikey.enable = true;

    chimera.input = {
      keyboard = {
        layout = "us";
        variant = "dvorak";
      };
      mouse.scrolling.natural = true;
    };

    chimera.nextcloud.enable = true;

    programs.bash.bashrcExtra = ''
      export PS1="\[\e]133;k;start_kitty\a\]\[\e]133;A\a\]\[\e]133;k;end_kitty\a\]\n\[\e]133;k;start_secondary_kitty\a\]\[\e]133;A;k=s\a\]\[\e]133;k;end_secondary_kitty\a\]\[\033[1;35m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] \[\e]133;k;start_suffix_kitty\a\]\[\e[5 q\]\[\e]2;\w\a\]\[\e]133;k;end_suffix_kitty\a\]"
    '';

    programs.kitty.extraConfig = ''
      map kitty_mod+enter launch --cwd=current --type=window
      map kitty_mod+t     launch --cwd=current --type=tab
    '';
  });
}
