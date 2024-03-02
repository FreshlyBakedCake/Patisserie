{
  inputs,
  pkgs,
  system,
  lib,
  config,
  ...
}:
{
  options.chimera.runner.anyrun = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether or not to enable the anyrun runner";
    };
  };

  config = {
    chimera.runner.enable = lib.mkIf config.chimera.runner.anyrun.enable true;

    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          inputs.anyrun.packages.${system}.applications
          inputs.anyrun.packages.${system}.rink
          inputs.anyrun.packages.${system}.shell
          inputs.anyrun.packages.${system}.translate
          inputs.anyrun.packages.${system}.kidex
          inputs.anyrun.packages.${system}.symbols
        ];

        # Styling as it's top level for some reason
        x = { fraction = 0.5; };
        y = { fraction = 0.3; };
        width = { fraction = 0.3; };
        closeOnClick = true;

      };
      extraCss = ''
      #window {
        background-color: transparent;
      }
      #main * {
        background-color: #${config.chimera.theme.colors.Surface0.hex};
        color: #${config.chimera.theme.colors.Text.hex};
        caret-color: alpha(#${config.chimera.theme.colors.Accent.hex},0.6);
        font-family: ${config.chimera.theme.font.variableWidth.sansSerif.name};
      }
      #main {
        border-width: 1px;
        border-style: solid;
        border-color: #${config.chimera.theme.colors.Accent.hex};
        border-radius: 5px;
      }
      #main #main {
        border-style: none;
        border-bottom-left-radius: 5px;
        border-bottom-right-radius: 5px;
      }
      #match-title, #match-desc {
        font-family: ${config.chimera.theme.font.variableWidth.sansSerif.name};
      }
      #entry {
        min-height: 36px;
        padding: 10px;
        font-size: 24px;
        box-shadow: none;
        border-style: none;
      }
      #entry:focus {
        box-shadow: none;
      }
      #entry selection {
        background-color: alpha(#${config.chimera.theme.colors.Yellow.hex},0.3);
        color: transparent;
      }
      '';
    };
  };
}
