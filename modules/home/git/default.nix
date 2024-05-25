{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.chimera.git = {
    gitReview.enable = lib.mkEnableOption "Enable git review";
    delta.enable = lib.mkEnableOption "Enable delta, an alternative pager for git diffs that highlights syntax";
    stgit.enable = lib.mkEnableOption "Install StGit, a tool that makes working with stacked patches easier";
    auth = {
      clicksUsername = lib.mkOption {
        type = lib.types.str;
        description = "Username for Clicks Gerrit";
      };
    };
    gpg = {
      enable = lib.mkEnableOption "Enable signing with gpg";
      commit = lib.mkOption {
        type = lib.types.bool;
        description = "Enable gpg signing for commits by default";
        default = true;
      };
      push = lib.mkOption {
        type = lib.types.bool;
        description = "Enable gpg signing for pushes by when asked by the server";
        default = true;
      };
    };
  };

  config = let
    urlReplacements = {
      aur = {
        http = "https://aur.archlinux.org/";
        ssh = "ssh://aur@aur.archlinux.org/";
      };
      aux = {
        http = "https://github.com/auxolotl/";
        ssh = "ssh://git@github.com/auxolotl/";
      };
      cb = {
        http = "https://codeberg.org/";
        ssh = "ssh://git@codeberg.org/";
      };
      clicks = {
        http = "https://git.clicks.codes/";
        ssh = "ssh://${config.chimera.git.auth.clicksUsername}@ssh.clicks.codes:29418/";
      };
      fdo = {
        http = "https://gitlab.freedesktop.org/";
        ssh = "ssh://git@gitlab.freedesktop.org/";
      };
      gh = {
        http = "https://github.com/";
        ssh = "ssh://git@github.com/";
      };
      gl = {
        http = "https://gitlab.com/";
        ssh = "ssh://git@gitlab.com/";
      };
      kde = {
        http = "https://invent.kde.org/";
        ssh = "ssh://git@invent.kde.org/";
      };
      lix = {
        http = "https://git.lix.systems/";
        ssh = "ssh://git@git.lix.systems/";
      };
    };

    replacementToHTTPInsteadOf = name: urls: {
      name = urls.http;
      value.insteadOf = "${name}:";
    };
    replacementToSSHInsteadOf = name: urls: {
      name = urls.ssh;
      value = {
        insteadOf = "p:${name}:";
        pushInsteadOf = [ urls.http "${name}:" ];
      };
    };

    replacementURLList =
      (lib.mapAttrsToList replacementToHTTPInsteadOf urlReplacements)
      ++ (lib.mapAttrsToList replacementToSSHInsteadOf urlReplacements);

    replacementURLs = builtins.listToAttrs replacementURLList;
  in {
    chimera.gpg.enable = lib.mkIf config.chimera.git.gpg.enable true;

    home.packages =
      (if config.chimera.git.gitReview.enable then [ pkgs.git-review ] else [ ])
      ++ (if config.chimera.git.stgit.enable then [ pkgs.stgit ] else [ ]);

    programs.zsh.shellAliases =
      if config.chimera.git.gitReview.enable then { "gr!" = "git review"; } else { };

    programs.bash.shellAliases =
      if config.chimera.git.gitReview.enable then { "gr!" = "git review"; } else { };

    programs.git = {
      enable = true;

      delta = {
        enable = config.chimera.git.delta.enable;
        options.light = lib.mkIf config.chimera.theme.catppuccin.enable (
          config.chimera.theme.catppuccin.style == "Latte"
        );
      };

      extraConfig = {
        init.defaultBranch = "main";
        advice.skippedcherrypicks = false;
        commit.gpgsign = lib.mkIf config.chimera.git.gpg.enable config.chimera.git.gpg.commit;
        credential.helper = "cache";
        core = {
          repositoryformatversion = 0;
          filemode = true;
          # TODO: from git docs, should we provide an option for this?: NOTE: this is a possibly dangerous operation; do not use it unless you understand the implications (see git-rebase[1] for details).
        };
        push = {
          autoSetupRemote = true;
          gpgSign = lib.mkIf config.chimera.git.gpg.enable (
            if config.chimera.git.gpg.push then "if-asked" else false
          );
        };
        pull.rebase = "merges";
        rebase.updateRefs = true;
        url = replacementURLs;
        merge.conflictstyle = "diff3";
        trailer.ifexists = "addIfDifferent";
      };
    };
  };
}
