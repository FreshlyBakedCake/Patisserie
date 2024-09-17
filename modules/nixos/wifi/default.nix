{ config, ... }:
{
  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    networks = {
      # Mini's house
      adelie24 = {
        pskRaw = "ext:newadelie24";
        priority = 25;
      };
      adelie50 = {
        pskRaw = "ext:newadelie50";
        priority = 50;
      };

      # Hills Road 6th Form College
      "HRSFC Wi-Fi".pskRaw = "ext:HRSFC_Wi_Fi";

      # Coded's house
      Orange2.pskRaw = "ext:Orange2";
      "Orange2_5G A" = {
        pskRaw = "ext:Orange2_5G_A";
        priority = 100;
      };

      # Pinea's house
      "OurVM2.4".pskRaw = "ext:OurVM2_4";

      # Moller institute
      "Moller" = {};
    };

    secretsFile = config.sops.secrets."modules/nixos/wifi/wifi-passwords.sops.chimera.env.bin".path;
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
