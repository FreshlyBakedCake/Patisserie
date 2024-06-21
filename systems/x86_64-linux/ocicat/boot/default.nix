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
    luks.devices."key".device = "/dev/disk/by-uuid/a703bd90-d5ff-42fe-b5b7-dfa696d665ca";
    luks.devices."NIXROOT" = {
      device = "/dev/disk/by-uuid/0ab9f369-f8a2-4522-bca6-024a5236290c";
      keyFile = "/key:/dev/mapper/key";
    };
    # luks.devices."BACKUPS" = {
    #   device = "/dev/disk/by-uuid/{FILL_IN}";
    #   keyFile = "/key:/dev/mapper/key";
    # };
  };
}
