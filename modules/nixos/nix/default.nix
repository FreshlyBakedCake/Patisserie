{ ... }:
{
  system.stateVersion = "24.05";
  console.keyMap = "dvorak";

  nix.settings = {
    builders-use-substitutes = true;

    substituters = [
      "https://cache.nixos.org"
      "https://anyrun.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
