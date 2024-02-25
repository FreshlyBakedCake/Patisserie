{ config, lib, pkgs, ... }:

{
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 1;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
}
