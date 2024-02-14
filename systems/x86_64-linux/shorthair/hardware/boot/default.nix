{ ... }:
{
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
    luks.devices."luks-bf23eee1-7cb7-43b9-822f-a9f49ea0a768".device = "/dev/disk/by-uuid/bf23eee1-7cb7-43b9-822f-a9f49ea0a768";
    luks.devices."luks-c38bc921-8979-4a25-9520-f3354dee3557".device = "/dev/disk/by-uuid/c38bc921-8979-4a25-9520-f3354dee3557";
  };
}
