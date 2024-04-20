{ config, ... }:
{
  users.users.pinea.hashedPasswordFile =
    config.sops.secrets."systems/x86_64-linux/saurosuchus/users/passwords.sops.pinea.json:pinea".path;

  chimera.yubikey.pam.enable = true;

  sops.secrets."systems/x86_64-linux/saurosuchus/users/passwords.sops.pinea.json:pinea" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./passwords.sops.pinea.json;
    format = "json";
    key = "pinea";
    neededForUsers = true;
  };
}
