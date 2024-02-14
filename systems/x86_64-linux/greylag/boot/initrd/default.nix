{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "uas"
    "usbhid"
    "sd_mod"
    "ext4"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.systemd.enable = true; # needed for the way we do our YubiKey
  boot.initrd.luks.devices."key".device = "/dev/disk/by-label/KEY";

  boot.initrd.luks.devices."luks-expansion0" = {
    device = "/dev/disk/by-label/EXPANSION0";
    keyFile = "/key:/dev/mapper/key";
  };
  boot.initrd.luks.devices."luks-ssd0" = {
    device = "/dev/disk/by-label/SSD0";
    keyFile = "/key:/dev/mapper/key";
  };
}
