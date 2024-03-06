{ ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
    "ext4"
  ];
  boot.initrd.kernelModules = [
    "kvm-amd"
    "amdgpu"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    systemd.enable = true; # needed for the way we do our YubiKey
    luks.devices."key".device = "/dev/disk/by-uuid/3ddef258-93b2-459c-9420-121b0631d69a";
    luks.devices."NIXROOT" = {
      device = "/dev/disk/by-uuid/744c83f8-f8d9-4604-8e44-ceb7bf7fdf87";
      keyFile = "/key:/dev/mapper/key";
    };
    luks.devices."BIGDATA" = {
      device = "/dev/disk/by-uuid/640b7c00-5cfa-472f-9338-c7adafa9ea6a";
      keyFile = "/key:/dev/mapper/key";
    };
  };
}
