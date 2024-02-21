{ config, ... }: {
  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    networks = {
      newadelie24 = {
        psk = "@newadelie24@";
        priority = 25;
      };
      newadelie50.psk = "@newadelie50@";
      adelie10 = {
        psk = "@adelie10@";
        priority = 50;
      };

      # Hills Road 6th Form College
      "HRSFC Wi-Fi".psk = "@HRSFC_Wi_Fi@";

      # Coded's house
      Orange2.psk = "@Orange2@";
      "Orange2_5G A" = {
        psk = "@Orange2_5G_A@";
        priority = 100;
      };
    };

    environmentFile = config.sops.secrets."modules/nixos/wifi/wifi-passwords.sops.chimera.env.bin".path;
  };

  hardware.enableRedistributableFirmware = true;

  sops.secrets."modules/nixos/wifi/wifi-passwords.sops.chimera.env.bin" = {
    mode = "0400";
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    sopsFile = ./wifi-passwords.sops.chimera.env.bin;
    format = "binary";
  };
}
