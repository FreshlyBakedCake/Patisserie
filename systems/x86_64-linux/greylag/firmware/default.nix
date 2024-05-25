{ config, lib, pkgs, ... }:

{
  services.fwupd.enable = true;
  services.tlp.settings.USB_AUTOSUSPEND = 0;
}
