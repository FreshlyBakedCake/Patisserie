{ config, ... }:
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
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [
    "nvidia"
    "v4l2loopback"
  ];
  boot.kernel.sysctl."kernel.sysrq" = 1;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    systemd.enable = true;  # Needed for the way we do our YubiKey
    luks.devices."key".device = "/dev/disk/by-uuid/f3547d7f-707e-4b17-a22b-d31b6af0a67a";
    luks.devices."MAIN" = {  # NVME, main storage, boot, etc (1TB)
      device = "/dev/disk/by-uuid/5183512d-92c1-4272-a746-8518ff7cde4b";
      keyFile = "/key:/dev/mapper/key";
    };
    luks.devices."LFS" = {  # PS3 HDD (0.5TB)
      device = "/dev/disk/by-uuid/2c636fd7-c664-46f7-986d-448d3ed60d28";
      keyFile = "/key:/dev/mapper/key";
    };
    # Commenting this out as it's the drive that's running while I'm writing the config
    # luks.devices."BACKUP" = {  # HDD (1TB)
    #   device = "/dev/disk/by-uuid/CHANGE_ME";
    #   keyFile = "/key:/dev/mapper/key";
    # };
  };
}
