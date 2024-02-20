{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/49f641f9-27c1-451e-9dff-d270879ede42";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F1F9-C8D5";
    fsType = "vfat";
  };

  #swapDevices = [
  #  {
  #    device = "/dev/disk/by-uuid/b0ffc786-a525-413d-97e8-24e57a39dd0b";
  #  }
  #];

}
