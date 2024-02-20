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

  users.users.coded = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    initialPassword = "nixos";
  };

  security.pam.services.waylock = { };
}
