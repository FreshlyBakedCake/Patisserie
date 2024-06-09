{ config, ... }: {
  networking.hostName = "greylag";
  networking.useDHCP = true;

  chimera.networking.tailscale.authKeyFile = config.sops.secrets."systems/x86_64-linux/greylag/networking/tailscale.sops.minion.json:authkey".path;

  sops.secrets."systems/x86_64-linux/greylag/networking/tailscale.sops.minion.json:authkey" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./tailscale.sops.minion.json;
    format = "json";
    key = "authkey";
  };
}
