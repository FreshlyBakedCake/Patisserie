{ pkgs, ... }:
{
  imports = [
    ./audio
    ./console
    ./compositor
    ./games
    ./hardware/boot
    ./hardware/cpu
    ./hardware/filesystems
    ./networking
    ./openrgb
    ./users
    ./time
    ./yubikey
  ];

  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "graphite" "development" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all all trust

      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };
}
