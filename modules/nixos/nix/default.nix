{ system, ... }:
{
  system.stateVersion = "24.05";

  nix.settings = {
    builders-use-substitutes = true;

    substituters = [
      "https://anyrun.cachix.org"
      "https://cache.lix.systems"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "@wheel"
    ];
  };

  nixpkgs.hostPlatform = system;
}
