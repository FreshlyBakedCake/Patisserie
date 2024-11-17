{
  lib
, config
, pkgs
, ...
}: let
  cfg = config.chimera.cooling.OpenLinkHub;
in {
  options.chimera.cooling.OpenLinkHub = {
    enable = lib.mkEnableOption "Enable OpenLinkHub service for Corsair iCUE Link";
    package = lib.mkOption {
      type = lib.types.package;
      description = "OpenLinkHub package to use for the module";
      default = pkgs.chimera.OpenLinkHub;
    };
    config = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.package}/var/lib/OpenLinkHub/config.json";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.OpenLinkHub = {};

    users.users.OpenLinkHub = {
      isSystemUser = true;
      group = config.users.groups.OpenLinkHub.name;
      extraGroups = [ config.users.groups.input.name ];
    };

    systemd.services.OpenLinkHub = let
      path = "/var/lib/OpenLinkHub";
    in {
      enable = true;
      description = "Open source interface for iCUE LINK System Hub, Corsair AIOs and Hubs";

      preStart = ''
        mkdir -p ${path}/database
        [ -f ${path}/database/rgb.json ] || cp ${cfg.package}/var/lib/OpenLinkHub/rgb.json ${path}/database/rgb.json
        mkdir -p ${path}/database/temperatures
        mkdir -p ${path}/database/profiles
        mkdir -p /run/udev/rules.d

        mkdir -p ${path}/database/keyboard
        cp -r -n ${cfg.package}/var/lib/OpenLinkHub/database/keyboard ${path}/database/keyboard

        cp ${cfg.config} ${path}/config.json

        [ -L ${path}/static ] || ln -s ${cfg.package}/var/lib/OpenLinkHub/static ${path}/static
        [ -L ${path}/web ] || ln -s ${cfg.package}/var/lib/OpenLinkHub/web ${path}/web

        ${pkgs.usbutils}/bin/lsusb -d 1b1c: | while read -r line; do
        ids=$(echo "$line" | ${pkgs.gawk}/bin/awk '{print $6}')
        vendor_id=$(${pkgs.coreutils}/bin/echo "$ids" | ${pkgs.coreutils}/bin/cut -d':' -f1)
        device_id=$(${pkgs.coreutils}/bin/echo "$ids" | ${pkgs.coreutils}/bin/cut -d':' -f2)
        ${pkgs.coreutils}/bin/cat > /run/udev/rules.d/99-corsair-openlinkhub-"$device_id".rules <<- EOM
        KERNEL=="hidraw*", SUBSYSTEMS=="usb", ATTRS{idVendor}=="$vendor_id", ATTRS{idProduct}=="$device_id", MODE="0666"
        EOM
        done

        ${pkgs.coreutils}/bin/chmod -R 744 ${path}
        ${pkgs.coreutils}/bin/chown -R OpenLinkHub:OpenLinkHub ${path}

        ${pkgs.systemd}/bin/udevadm control --reload
        ${pkgs.systemd}/bin/udevadm trigger
      '';

      postStop = ''
        ${pkgs.coreutils}/bin/rm /var/lib/OpenLinkHub/web
        ${pkgs.coreutils}/bin/rm /var/lib/OpenLinkHub/static

        ${pkgs.coreutils}/bin/rm /run/udev/rules.d/99-corsair-openlinkhub-*.rules
        ${pkgs.systemd}/bin/udevadm control --reload
        ${pkgs.systemd}/bin/udevadm trigger
      '';

      path = [ pkgs.pciutils ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/OpenLinkHub";
        ExecReload = "${pkgs.coreutils}/bin/kill -s HUP \$MAINPID";
        RestartSec = 5;
        PermissionsStartOnly = true;
        StateDirectory = "OpenLinkHub";
        WorkingDirectory = "/var/lib/OpenLinkHub";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
