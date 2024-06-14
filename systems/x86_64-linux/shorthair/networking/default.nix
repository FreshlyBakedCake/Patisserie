{ lib, config, ... }:
{
  networking = {
    hostName = "shorthair";
    useDHCP = lib.mkDefault true;
  };

  chimera.networking.tailscale.authKeyFile = config.sops.secrets."systems/x86_64-linux/shorthair/networking/tailscale.sops.coded.json:authkey".path;

  sops.secrets."systems/x86_64-linux/shorthair/networking/tailscale.sops.coded.json:authkey" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./tailscale.sops.coded.json;
    format = "json";
    key = "authkey";
  };
}
