{ lib, config, ... }: {
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-${lib.strings.toLower config.chimera.theme.style}";
}
