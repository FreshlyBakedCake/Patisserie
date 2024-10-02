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

    firefox-sidebery-gnome = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jujutsu = {
      url = "github:martinvonz/jj?rev=a43b0cde97e14b92dace47ead9f0e968310cab4e";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.91.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        niri-unstable.follows = "niri-flake/niri-stable";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    radicle.url = "git+https://seed.radicle.xyz/z3gqcJUoA1n9HaHKufZs5FCSGazv5.git";

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    templates.url = "git+https://git.clicks.codes/Templates";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = [
        inputs.emacs-overlay.overlays.default
        inputs.niri-flake.overlays.niri
      ];

      homes.modules = [
        inputs.anyrun.homeManagerModules.default
        inputs.nur.hmModules.nur
        inputs.nix-index-database.hmModules.nix-index
        inputs.sops-nix.homeManagerModules.sops
        inputs.niri-flake.homeModules.niri
      ];

      systems.modules.nixos = [
        inputs.nur.nixosModules.nur
        inputs.sops-nix.nixosModules.sops
        inputs.lix-module.nixosModules.default
      ];

      systems.hosts.greylag.modules = [
        inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
      ];

      snowfall = {
        namespace = "chimera";

        meta.name = "chimera";
        meta.title = "A Well Opinionated Nix Configurations";
      };

      outputs-builder = channels: {
        formatter = nixpkgs.legacyPackages.${channels.nixpkgs.system}.nixfmt-rfc-style;
      };

      channels-config = {
        allowUnfree = true;
      };
    };
}
