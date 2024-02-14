{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.chimera.editor.ed = {
    enable = lib.mkEnableOption "Enable the standard text editor, the greatest WYGIWYG editor of all, the only viable text editor, Ed";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      description = "Use Ed as the default editor";
      default = true;
    };
  };

  config = lib.mkIf config.chimera.editor.ed.enable {
    home.packages = [ pkgs.ed ];

    home.sessionVariables = lib.mkIf config.chimera.editor.ed.defaultEditor {
      EDITOR = "${pkgs.ed}/bin/ed";
    };
  };
}
