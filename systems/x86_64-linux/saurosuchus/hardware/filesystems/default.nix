{ ... }:
{
  fileSystems."/" = {
    device = "/dev/mapper/MAIN";
    fsType = "btrfs";
  };

  fileSystems."/lfs" = {
    device = "/dev/mapper/LFS";
    fsType = "ext4";
  };

  # fileSystems."/backups" = {
  #   device = "/dev/mapper/BACKUP";
  #   fsType = "btrfs";
  # };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DCBE-AA38";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/c956d054-0dda-42c1-950d-26aefd3a8135";
    }
  ];
}
