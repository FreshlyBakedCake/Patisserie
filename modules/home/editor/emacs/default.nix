{ pkgs, config, lib, ... }:
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
      client = {
        enable = true;
        arguments = [ "--create-frame" "--alternate-editor=${config.programs.emacs.package}/bin/emacs" ];
      };
    };

    /* we already have emacsclient.desktop which starts emacs if the server is not up, so emacs.desktop only serves to get in the way */
    home.packages = [
      (lib.pipe {
        "Desktop Entry" = {
          Type = "Application";
          NoDisplay = true;
        };
      } [
        (lib.generators.toINI { })
        (pkgs.writeTextDir "share/applications/emacs.desktop")
        lib.hiPrio
      ])
    ];
  };
}
