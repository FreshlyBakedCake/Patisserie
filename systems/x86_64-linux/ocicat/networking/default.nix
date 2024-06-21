{ lib, config, ... }:
{
  networking = {
    hostName = "ocicat";
    useDHCP = lib.mkDefault true;
  };
}
