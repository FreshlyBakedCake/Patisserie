{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/63caf2b5-90d4-49a7-99e9-98dcdd797859";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5B78-4B2D";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/3a9212d4-6c39-4d5b-abf0-49294bd991c9"; } ];
}
