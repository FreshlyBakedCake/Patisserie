{ ... }:
{
  fileSystems."/" = {
    device = "/dev/mapper/NIXROOT";
    fsType = "btrfs";
  };

  # fileSystems."/backups" = {
  #   device = "/dev/mapper/BACKUPS";
  #   fsType = "btrfs";
  # };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/90EA-208A";
    fsType = "vfat";
    options = [ "umask=0022" ];
  };
}
