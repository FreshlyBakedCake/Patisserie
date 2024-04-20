{ config, lib, pkgs, ... }:
{
  chimera.yubikey.enable = true;
  chimera.yubikey.pam.enable = true;
}
