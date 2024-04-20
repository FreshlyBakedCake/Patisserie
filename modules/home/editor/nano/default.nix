{ config, lib, pkgs, ... }:
{
  options.chimera.editor.nano = {
    enable = lib.mkEnableOption "Enable nano editor";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      description = "Use nano as the default editor";
      default = true;
    };
  };

  config = lib.mkIf config.chimera.editor.nano.enable {
    home.packages = [ pkgs.nano ];

    home.sessionVariables = lib.mkIf config.chimera.editor.nano.defaultEditor {
      EDITOR = "${pkgs.nano}/bin/nano";
    };
  };
}
