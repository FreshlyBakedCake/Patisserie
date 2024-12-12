{ config, lib, ... }:
{
  options.chimera.editor.helix = {
    enable = lib.mkEnableOption "Enable helix editor";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      description = "Use helix as the default editor";
      default = true;
    };
  };

  config = lib.mkIf config.chimera.editor.helix.enable {
    programs.helix = {
      enable = true;
      defaultEditor = config.chimera.editor.helix.defaultEditor;
      settings.theme = lib.mkIf config.chimera.theme.catppuccin.enable "catppuccin_${lib.strings.toLower config.chimera.theme.catppuccin.style}";
    };
  };
}
