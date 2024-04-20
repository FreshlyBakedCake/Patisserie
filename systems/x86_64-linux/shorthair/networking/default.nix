{ lib, ... }:
{
  networking = {
    hostName = "shorthair";
    useDHCP = lib.mkDefault true;
  };
}
