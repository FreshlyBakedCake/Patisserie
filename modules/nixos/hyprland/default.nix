{ pkgs, lib, ... }:
{
  programs.hyprland.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  chimera.xdg-open.enable = lib.mkDefault true;
}
