{ config, ... }:
{
  users.users.coded.hashedPasswordFile =
    config.sops.secrets."systems/x86_64-linux/shorthair/users/passwords.sops.coded.json:coded".path;

  sops.secrets."systems/x86_64-linux/shorthair/users/passwords.sops.coded.json:coded" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./passwords.sops.coded.json;
    format = "json";
    key = "coded";
    neededForUsers = true;
  };
}
