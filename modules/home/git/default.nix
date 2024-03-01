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

  config = {
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
        url = {
          "ssh://git@github.com/".pushInsteadOf = "https://github.com/";
          "ssh://${config.chimera.git.auth.clicksUsername}@ssh.clicks.codes:29418/".pushInsteadOf = "https://git.clicks.codes/";
        };
        merge.conflictstyle = "diff3";
        trailer.ifexists = "addIfDifferent";
      };
    };
  };
}

/* [alias]
   	recommit = "!git commit --verbose -eF $(git rev-parse --git-dir)/COMMIT_EDITMSG"
   	stash-working = "!f() { \
   		git commit --quiet --no-verify -m \"temp for stash-working\" && \
           	git stash push \"$@\" && \
           	git reset --quiet --soft HEAD~1; \
   	}; f"
   	checkout-soft = "!f() { \
   	   hash=$(git hash); \
   	   git checkout \"$@\"; \
   	   git reset --soft $hash; \
   	}; f" # basically the opposite of a soft reset: change all the files but do not change the HEAD reference
   	graph = "log --graph --oneline --decorate"
   	fmt = "clang-format"
   	hash = "rev-parse HEAD"
   	fmt-last = "!f() { \
   		hash=$(git hash); \
   		git reset --soft HEAD^ && \
   		git fmt; \
   		git reset --soft $hash; \
   	}; f"
   	personal = "config user.email skyler3665@gmail.com"
   	clicks = "config user.email minion@clicks.codes"
   	collabora = "config user.email skyler.grey@collabora.com"
   	# review = "!git-review -T": cannot be set here, set in .zshrc instead

   [credential]
   	helper = "store"

   /*
   [user]
   	name = "Skyler Grey"
   	signingkey = "7C868112B5390C5C"
     useConfigOnly = true # avoid auto-setting user.email by hostname

   [alias]
   	recommit = "!git commit --verbose -eF $(git rev-parse --git-dir)/COMMIT_EDITMSG"
   	stash-working = "!f() { \
   		git commit --quiet --no-verify -m \"temp for stash-working\" && \
           	git stash push \"$@\" && \
           	git reset --quiet --soft HEAD~1; \
   	}; f"
   	checkout-soft = "!f() { \
   	   hash=$(git hash); \
   	   git checkout \"$@\"; \
   	   git reset --soft $hash; \
   	}; f" # basically the opposite of a soft reset: change all the files but do not change the HEAD reference
   	graph = "log --graph --oneline --decorate"
   	fmt = "clang-format"
   	hash = "rev-parse HEAD"
   	fmt-last = "!f() { \
   		hash=$(git hash); \
   		git reset --soft HEAD^ && \
   		git fmt; \
   		git reset --soft $hash; \
   	}; f"
   	personal = "config user.email skyler3665@gmail.com"
   	clicks = "config user.email minion@clicks.codes"
   	collabora = "config user.email skyler.grey@collabora.com"
   	# review = "!git-review -T": cannot be set here, set in .zshrc instead

   [init]
   	defaultBranch = "main"

   [color]
   	ui = "auto"

   [core]
   	autocrlf = "input"
   	splitIndex = true
   	untrackedCache = true
   	fsmonitor = true
   	pager = "delta"

   [pull]
   	rebase = merges

   [push]
   	autoSetupRemote = true
   	useForceIfIncludes = true
   	gpgSign = if-asked

   [credential]
   	helper = "store"

   [commit]
   	gpgsign = true

   [url "ssh://git@github.com/"]
   	pushInsteadOf = "https://github.com/"

   [interactive]
   	diffFilter = "delta --color-only"

   [delta]
   	navigate = true
   	light = false
   	line-numbers = true
   	features = "my-dark-theme zebra-dark"

   [merge]
   	conflictstyle = "diff3"

   [diff]
   	colorMoved = "default"

   [trailer]
   	ifexists = "addIfDifferent"
*/
