{ inputs, ... }:
{
  nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
}
