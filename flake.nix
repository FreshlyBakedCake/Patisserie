{
  description = "The Chimera nix configuration flake, a shared system configuration";

  inputs = {
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    collabora-gtimelog = {
      url = "git+https://gitlab.collabora.com/collabora/gtimelog.git";
      flake = false;
    };
    collabora-icon = {
      url = "https://www.collabora.com/favicon.ico";
      flake = false;
    };

    ewwsalmoomedits--eww-widgets = {
      url = "github:saimoomedits/eww-widgets";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    templates.url = "git+https://git.clicks.codes/Templates";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      homes.modules = [
        inputs.anyrun.homeManagerModules.default
        inputs.hyprland.homeManagerModules.default
        inputs.nur.hmModules.nur
        inputs.nix-index-database.hmModules.nix-index
        inputs.sops-nix.homeManagerModules.sops
      ];

      systems.modules.nixos = [
        inputs.hyprland.nixosModules.default
        inputs.nur.nixosModules.nur
        inputs.sops-nix.nixosModules.sops
      ];

      systems.hosts.greylag.modules = [
        inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
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
