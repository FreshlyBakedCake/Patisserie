{ inputs, system, lib, ... }:
{
  nix.package = lib.mkDefault inputs.lix-module.packages.${system}.default; # Snowfall will override default nix.package by system nix if running on a nixos system
}
