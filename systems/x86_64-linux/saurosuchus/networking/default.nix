{ lib, ... }:
{
  networking = {
    hostName = "saurosuchus";
    useDHCP = lib.mkDefault true;
    firewall.allowedTCPPorts = [ 25566 3000 3001 ];
  };
}
