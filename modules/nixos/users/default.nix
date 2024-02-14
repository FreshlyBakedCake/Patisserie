{ pkgs, ... }:
{
  users.users.minion = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
    ];
    initialPassword = "nixos";
  };

  security.pam.services.waylock = { };
}
