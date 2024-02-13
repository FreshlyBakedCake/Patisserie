{ ... }:
{
  programs.hyprland.enable = true;

  users.users.minion.extraGroups = [ "input" ];
}
