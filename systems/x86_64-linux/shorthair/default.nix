{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.initrd = {
    luks.devices."luks-bf23eee1-7cb7-43b9-822f-a9f49ea0a768".device =
      "/dev/disk/by-uuid/bf23eee1-7cb7-43b9-822f-a9f49ea0a768";
    luks.devices."luks-c38bc921-8979-4a25-9520-f3354dee3557".device =
      "/dev/disk/by-uuid/c38bc921-8979-4a25-9520-f3354dee3557";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/63caf2b5-90d4-49a7-99e9-98dcdd797859";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5B78-4B2D";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/3a9212d4-6c39-4d5b-abf0-49294bd991c9"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
