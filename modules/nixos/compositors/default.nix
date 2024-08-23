{ pkgs, lib, config, ... }:
{
  options.chimera.compositors = {
    hyprland.enable = lib.mkEnableOption "Enable if at least 1 user on the system uses hyprland";
    niri.enable = lib.mkEnableOption "Enable if at least 1 user on the system uses niri";
  };

  config = {
    fonts.enableDefaultPackages = lib.mkDefault true;
    hardware.graphics.enable = lib.mkDefault true;

    programs.hyprland.enable = config.chimera.compositors.hyprland.enable;

    xdg.portal.enable = lib.mkIf config.chimera.compositors.niri.enable true;
    xdg.portal.config.common.default = "*"; # HACK: fixme @minion3665, try removing this and check the warning

    xdg.portal.extraPortals = lib.mkIf (
      config.chimera.compositors.hyprland.enable
      || config.chimera.compositors.niri.enable
    ) [ pkgs.xdg-desktop-portal-gtk ];

    programs.dconf.enable = true; # FIXME: should be set to true if gtk is being used

    security.polkit.enable = true;

    chimera.xdg-open.enable = lib.mkDefault true;
  };
}
