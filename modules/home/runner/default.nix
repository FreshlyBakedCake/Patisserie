{ lib, config, ... }: {
  options = {
    chimera.runner.enable = lib.mkEnableOption "Enable an app runner on the system";
  };
}