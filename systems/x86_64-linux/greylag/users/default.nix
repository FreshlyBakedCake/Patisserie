{ config, ... }:
{
  users.users.minion.hashedPasswordFile =
    config.sops.secrets."systems/x86_64-linux/greylag/users/passwords.sops.minion.json:minion".path;

  sops.secrets."systems/x86_64-linux/greylag/users/passwords.sops.minion.json:minion" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./passwords.sops.minion.json;
    format = "json";
    key = "minion";
    neededForUsers = true;
  };
}
