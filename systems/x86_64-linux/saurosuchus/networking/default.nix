{ lib, ... }:
{
  networking = {
    hostName = "saurosuchus";
    useDHCP = lib.mkDefault true;
  };
}
