{
  description = "The Chimera nix configuration flake, a shared system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ewwsalmoomedits--eww-widgets = {
      url = "github:saimoomedits/eww-widgets";
      flake = false;
    };

    nur.url = "github:nix-community/nur";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      homes.modules = [
        # TODO: inputs.nix-index-database.hmModules.nix-index
      ];

      homes.users."minion@greylag".modules = [
        inputs.hyprland.homeManagerModules.default
        inputs.anyrun.homeManagerModules.default
        inputs.nur.hmModules.nur
      ];

      system.modules.nixos = [
        inputs.hyprland.nixosModules.default
        inputs.nur.nixosModules.nur
      ];

      snowfall = {
        namespace = "chimera";

        meta.name = "chimera";
        meta.title = "Coded and Minion's Nix Configurations";
      };

      outputs-builder = channels: {
        formatter = nixpkgs.legacyPackages.${channels.nixpkgs.system}.nixfmt-rfc-style;
      };

      channels-config = {
        allowUnfree = true;
      };
    };
}
