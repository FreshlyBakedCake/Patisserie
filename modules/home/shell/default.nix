{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.chimera.shell = {
    rebuildFlakePath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Full path to where you store your flake locally";
      default = null;
    };
    defaultAliases.enable = lib.mkEnableOption "Use sensible custom aliases";
    usefulPackages.enable = lib.mkEnableOption "Enable useful shell packages (ripgrep, wget, etc)";
    replacements = {
      defaultEnable = lib.mkEnableOption "Enable replacing everything by default";

      atuin = {
        enable = lib.mkOption {
          description = "Use atuin instead of bkd-i-search";
          type = lib.types.bool;
          default = config.chimera.shell.replacements.defaultEnable;
          example = true;
        };
        enableUpArrow = lib.mkEnableOption "Pressing up arrow will enter atuin instead of scrolling back through history";
      };

      eza.enable = lib.mkOption {
        description = "Use eza instead of ls";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      bfs.enable = lib.mkOption {
        description = "Use bfs instead of find";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      ripgrep.enable = lib.mkOption {
        description = "Use ripgrep instead of grep";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      htop.enable = lib.mkOption {
        description = "Use htop instead of top";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      erdtree.enable = lib.mkOption {
        description = "Use erdtree instead of tree";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      dust.enable = lib.mkOption {
        description = "Use dust instead of du";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      bat.enable = lib.mkOption {
        description = "Use bat instead of cat";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      zoxide.enable = lib.mkOption {
        description = "Use zoxide instead of cd";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
      glow.enable = lib.mkOption {
        description = "Use glow for cat-ing .md files";
        type = lib.types.bool;
        default = config.chimera.shell.replacements.defaultEnable;
        example = true;
      };
    };
  };

  config = {
    home.shellAliases = lib.mkIf config.chimera.shell.defaultAliases.enable (
      let
        any_cat_replacement = config.chimera.shell.replacements.glow.enable || config.chimera.shell.replacements.bat.enable;
        cat_or_bat = if config.chimera.shell.replacements.bat.enable then "${pkgs.bat}/bin/bat" else "${pkgs.coreutils}/bin/cat";
        glow_or_cat_or_bat = if config.chimera.shell.replacements.glow.enable
          then builtins.toString (pkgs.writeScript "glow_or_cat_or_bat" ''
              if [[ "$1" == *.md ]]; then
                ${pkgs.glow}/bin/glow "$@"
              else
                ${cat_or_bat} "$@"
              fi
            '')
          else cat_or_bat;
      in {
      rebuild =
        lib.mkIf (config.chimera.shell.rebuildFlakePath != null)
          "sudo nixos-rebuild switch --flake ${config.chimera.shell.rebuildFlakePath}";
      clr = "clear";
      edit = builtins.toString config.home.sessionVariables.EDITOR;
      find = lib.mkIf config.chimera.shell.replacements.bfs.enable "${pkgs.bfs}/bin/bfs";
      grep = lib.mkIf config.chimera.shell.replacements.ripgrep.enable "${config.programs.ripgrep.package}/bin/rg --include-zero";
      top = lib.mkIf config.chimera.shell.replacements.htop.enable "${config.programs.htop.package}/bin/htop";
      tree = lib.mkIf config.chimera.shell.replacements.erdtree.enable "${pkgs.erdtree}/bin/erdtree";
      du = lib.mkIf config.chimera.shell.replacements.dust.enable "${pkgs.dust}/bin/dust";
      cat = lib.mkIf any_cat_replacement glow_or_cat_or_bat;
      lix = "${config.nix.package}/bin/nix"; # Lix, like nix
    });

    home.sessionVariables = lib.mkIf (config.chimera.shell.usefulPackages.enable && config.chimera.theme.style == "Light") {
      BAT_THEME = "OneHalfLight";
    };

    programs.atuin = lib.mkIf config.chimera.shell.replacements.atuin.enable {
      enable = true;
      enableZshIntegration = config.chimera.shell.zsh.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
      flags = lib.mkIf (!config.chimera.shell.replacements.atuin.enableUpArrow) [ "--disable-up-arrow" ];
    };

    programs.eza = lib.mkIf config.chimera.shell.replacements.eza.enable {
      enable = true;
      enableZshIntegration = config.chimera.shell.zsh.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
    };

    programs.ripgrep = lib.mkIf config.chimera.shell.replacements.ripgrep.enable {
      enable = true;
      arguments = [ "--smart-case" ];
    };

    programs.htop = lib.mkIf config.chimera.shell.replacements.htop.enable { enable = true; };

    programs.zoxide = lib.mkIf config.chimera.shell.replacements.zoxide.enable {
      enable = true;
      enableZshIntegration = config.chimera.shell.zsh.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
      options = [ "--cmd cd" ];
    };

    programs.tealdeer = lib.mkIf config.chimera.shell.usefulPackages.enable {
      enable = true;
      settings.updates = {
        auto_update = true;
        auto_update_interval_hours = 72;
      };
    };
    programs.jq = lib.mkIf config.chimera.shell.usefulPackages.enable { enable = true; };

    home.packages =
      (
        if config.chimera.shell.usefulPackages.enable then
          [
            pkgs.wget
            pkgs.bat
            pkgs.curl
            pkgs.curlie
            pkgs.pv
            pkgs.sd
            pkgs.tokei
            pkgs.hyperfine
            pkgs.tmux
            pkgs.glow
          ]
        else
          [ ]
      )
      ++ (if config.chimera.shell.replacements.bfs.enable then [ pkgs.bfs ] else [ ])
      ++ (if config.chimera.shell.replacements.htop.enable then [ pkgs.htop ] else [ ])
      ++ (if config.chimera.shell.replacements.erdtree.enable then [ pkgs.erdtree ] else [ ])
      ++ (if config.chimera.shell.replacements.dust.enable then [ pkgs.dust ] else [ ]);
  };
}
