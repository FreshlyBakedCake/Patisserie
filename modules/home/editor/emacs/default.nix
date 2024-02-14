{ config, lib, ... }:
{
  options.chimera.editor.emacs = {
    enable = lib.mkEnableOption "Enable emacs editor";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      description = "Use emacs as the default editor";
      default = true;
    };
  };

  config = lib.mkIf config.chimera.editor.emacs.enable {
    programs.emacs.enable = true;
    services.emacs = {
      enable = true;
      defaultEditor = config.chimera.editor.emacs.defaultEditor;
    };
  };
}
