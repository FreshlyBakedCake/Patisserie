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
    };
  };

  config = {
    home.shellAliases = lib.mkIf config.chimera.shell.defaultAliases.enable {
      rebuild =
        lib.mkIf (config.chimera.shell.rebuildFlakePath != null)
          "sudo nixos-rebuild switch --flake ${config.chimera.shell.rebuildFlakePath}";
      clr = "clear";
      edit = config.home.sessionVariables.EDITOR;
      find = lib.mkIf config.chimera.shell.replacements.bat.enable "${pkgs.bfs}/bin/bfs";
      grep = lib.mkIf config.chimera.shell.replacements.bat.enable "${config.programs.ripgrep.package}/bin/rg";
      top = lib.mkIf config.chimera.shell.replacements.bat.enable "${config.programs.htop.package}/bin/htop";
      tree = lib.mkIf config.chimera.shell.replacements.bat.enable "${pkgs.erdtree}/bin/erdtree";
      du = lib.mkIf config.chimera.shell.replacements.bat.enable "${pkgs.dust}/bin/dust";
      cat = lib.mkIf config.chimera.shell.replacements.bat.enable "${pkgs.bat}/bin/bat";
    };

    programs.eza = lib.mkIf config.chimera.shell.replacements.eza.enable {
      enable = true;
      enableAliases = true;
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
      settings.updates.autoupdate = true;
    };
    programs.jq = lib.mkIf config.chimera.shell.usefulPackages.enable { enable = true; };

    home.packages =
      (
        if config.chimera.shell.usefulPackages.enable then
          [
            pkgs.wget
            pkgs.curl
            pkgs.curlie
            pkgs.pv
            pkgs.sd
            pkgs.tokei
            pkgs.hyperfine
            pkgs.tmux
          ]
        else
          [ ]
      )
      ++ (if config.chimera.shell.replacements.bfs.enable then [ pkgs.bfs ] else [ ])
      ++ (if config.chimera.shell.replacements.htop.enable then [ pkgs.htop ] else [ ])
      ++ (if config.chimera.shell.replacements.erdtree.enable then [ pkgs.erdtree ] else [ ])
      ++ (if config.chimera.shell.replacements.dust.enable then [ pkgs.dust ] else [ ])
      ++ (if config.chimera.shell.replacements.bat.enable then [ pkgs.bat ] else [ ]);
  };
}
