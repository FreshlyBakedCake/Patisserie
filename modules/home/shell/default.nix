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
      eza.enable = lib.mkEnableOption "Use eza instead of ls";
      bfs.enable = lib.mkEnableOption "Use bfs instead of find";
      ripgrep.enable = lib.mkEnableOption "Use ripgrep instead of grep";
      htop.enable = lib.mkEnableOption "Use htop instead of top";
      erdtree.enable = lib.mkEnableOption "Use erdtree instead of tree";
      dust.enable = lib.mkEnableOption "Use dust instead of du";
      bat.enable = lib.mkEnableOption "Use bat instead of cat";
    };
  };

  config = {
    home.shellAliases = lib.mkIf config.chimera.shell.defaultAliases.enable {
      rebuild =
        lib.mkIf (config.chimera.shell.rebuildFlakePath != null)
          "sudo nixos-rebuild switch --flake ${config.chimera.shell.rebuildFlakePath}";
      clr = "clear";
      edit = config.home.sessionVariables.EDITOR;
    };

    programs = lib.mkIf config.chimera.shell.usefulPackages.enable {
      tealdeer = {
        enable = true;
        settings.updates.autoupdate = true;
      };
      jq.enable = true;
    };

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
          ]
        else
          [ ]
      )
      ++ (if config.chimera.shell.replacements.eza.enable then [ pkgs.eza ] else [ ])
      ++ (if config.chimera.shell.replacements.bfs.enable then [ pkgs.bfs ] else [ ])
      ++ (if config.chimera.shell.replacements.ripgrep.enable then [ pkgs.ripgrep ] else [ ])
      ++ (if config.chimera.shell.replacements.htop.enable then [ pkgs.htop ] else [ ])
      ++ (if config.chimera.shell.replacements.erdtree.enable then [ pkgs.erdtree ] else [ ])
      ++ (if config.chimera.shell.replacements.dust.enable then [ pkgs.dust ] else [ ])
      ++ (if config.chimera.shell.replacements.bat.enable then [ pkgs.bat ] else [ ]);
  };
}
