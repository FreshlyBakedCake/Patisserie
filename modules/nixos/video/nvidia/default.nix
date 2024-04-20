{ lib, config, ... }:
{
  options.chimera.nvidia.enable = lib.mkEnableOption "Enable NVIDIA hardware support";

  config = {
    services.xserver.videoDrivers = lib.mkIf config.chimera.nvidia.enable ["nvidia"];
    hardware.nvidia = lib.mkIf config.chimera.nvidia.enable {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
