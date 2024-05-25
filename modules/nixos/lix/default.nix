{ inputs, system, ... }:
{
  nix.package = inputs.lix-module.packages.${system}.default;
}
