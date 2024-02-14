{ lib, ... }:
{

  networking = {
    hostname = "shorthair";
    useDHCP = lib.mkDefault true;
  };
}
