{ lib, ... }:
{
  fileSystems =
    (lib.mapAttrs
      (_: share_name: {
        device = "/dev/disk/by-label/BTRFS0";
        fsType = "btrfs";
        options = [
          "subvol=shared/${share_name}"
          "compress=zstd:1"
        ];
      })
      {
        "/home/minion/Code" = "@Code";
        "/var/lib/containers" = "@containers";
        "/etc/NetworkManager" = "@NetworkManager";
        "/home/minion/.local/share/containers/storage" = "@personal-containers";
        "/home/minion/.gtimelog" = "@gtimelog";
        "/home/minion/Documents" = "@documents";
      }
    )
    // {
      "/mnt" = {
        device = "/dev/mapper/key";
        fsType = "ext4";
      };

      "/" = {
        device = "/dev/disk/by-label/BTRFS0";
        fsType = "btrfs";
        options = [
          "subvol=@nixos"
          "compress=zstd:1"
        ];
      };

      "/var" = {
        device = "/dev/disk/by-label/BTRFS0";
        fsType = "btrfs";
        options = [
          "subvol=@nixos-var"
          "compress=zstd:1"
        ];
      };

      "/home" = {
        device = "/dev/disk/by-label/BTRFS0";
        fsType = "btrfs";
        options = [
          "subvol=@nixos-home"
          "compress=zstd:1"
        ];
      };

      "/nix" = {
        device = "/dev/disk/by-label/BTRFS0";
        fsType = "btrfs";
        options = [
          "subvol=@nixos-nix"
          "compress=zstd:1"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };
    };

  swapDevices = [ ];
}
