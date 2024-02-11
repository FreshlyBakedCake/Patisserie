{ config, lib, pkgs, ... }:

{
  xdg.enable = true;

  home.packages = [ pkgs.nix-index ];
}
