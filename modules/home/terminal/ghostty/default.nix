{
  inputs,
  config,
  lib,
  system,
  pkgs,
  ...
}: let
  cfg = config.chimera.terminal.ghostty;
in {
  options.chimera.terminal.ghostty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Use ghostty as your terminal";
      default = true;
    };
    default = lib.mkOption {
      type = lib.types.bool;
      description = "Use ghostty as your default terminal";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    chimera.terminal.default = lib.mkIf cfg.default "${inputs.ghostty.packages.${system}.ghostty}/bin/ghostty";

    home.packages = [
      inputs.ghostty.packages.${system}.ghostty
    ];

    gtk.enable = true;
    gtk.iconTheme.package = pkgs.libsForQt5.breeze-icons;
    gtk.iconTheme.name = "breeze";

    xdg.configFile."ghostty/config" = lib.mkIf config.chimera.theme.catppuccin.enable {
      text = ''
        theme = catppuccin-${lib.strings.toLower config.chimera.theme.catppuccin.style}
      '';
    };
  };
}
