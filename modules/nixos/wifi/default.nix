{ ... }: {
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
}
