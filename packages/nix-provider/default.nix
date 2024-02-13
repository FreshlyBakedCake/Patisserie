{ writeShellScriptBin, ... }:
writeShellScriptBin "nix-provider" (builtins.readFile ./nix-provider.sh)
