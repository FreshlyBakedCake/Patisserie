{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }: {
  networking.hostName = "greylag";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "uas" "usbhid" "sd_mod" "ext4" ];
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

  fileSystems = (lib.mapAttrs (_: share_name: {
    device = "/dev/disk/by-label/BTRFS0";
    fsType = "btrfs";
    options = [ "subvol=shared/${share_name}" "compress=zstd:1" ];
  }) {
    "/home/minion/Code" = "@Code";
    "/var/lib/containers" = "@containers";
    "/etc/NetworkManager" = "@NetworkManager";
    "/home/minion/.local/share/containers/storage" = "@personal-containers";
    "/home/minion/.gtimelog" = "@gtimelog";
    "/home/minion/Documents" = "@documents";
  }) // {
    "/mnt" = {
      device = "/dev/mapper/key";
      fsType = "ext4";
    };

    "/" = {
      device = "/dev/disk/by-label/BTRFS0";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd:1" ];
    };

    "/var" = {
      device = "/dev/disk/by-label/BTRFS0";
      fsType = "btrfs";
      options = [ "subvol=@nixos-var" "compress=zstd:1" ];
    };

    "/home" = {
      device = "/dev/disk/by-label/BTRFS0";
      fsType = "btrfs";
      options = [ "subvol=@nixos-home" "compress=zstd:1" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/BTRFS0";
      fsType = "btrfs";
      options = [ "subvol=@nixos-nix" "compress=zstd:1" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u4u4u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
