{ config, lib, ... }:
{
  options.chimera.editor.neovim = {
    enable = lib.mkEnableOption "Enable neovim editor";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      description = "Use neovim as the default editor";
      default = true;
    };
  };

  config = lib.mkIf config.chimera.editor.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = config.chimera.editor.neovim.defaultEditor;
    };
  };
}
