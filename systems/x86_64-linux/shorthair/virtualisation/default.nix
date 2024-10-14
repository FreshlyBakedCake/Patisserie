{ pkgs, ... }: {
  virtualisation.spiceUSBRedirection.enable = true;
  environment.systemPackages = [ pkgs.quickemu pkgs.spice-gtk ];
}
