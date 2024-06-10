{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.chimera.networking.tailscale;
in
{
  options.chimera.networking.tailscale = {
    enable = lib.mkOption {
      description = "Enable tailscale for this system";
      default = true;
      type = lib.types.bool;
    };
    runExitNode.enable = lib.mkEnableOption "Enable this system as an exit node on the tailnet";
    server = lib.mkOption {
      description = "Set where your control plane server is";
      default = "https://clicks.domains";
      example = "https://controlplane.tailscale.com";
    };
    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Path to key file for tailscale";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = if cfg.runExitNode.enable then "both" else "client";
      extraUpFlags =
        [
          "--login-server=${cfg.server}"
          "--accept-routes"
        ]
        ++ (
          if cfg.runExitNode.enable then
            [
              "--advertise-exit-node"
              "--exit-node-allow-lan-access"
            ]
          else
            [ ]
        );
      authKeyFile = lib.mkIf (cfg.authKeyFile != null) cfg.authKeyFile;
    };
  };
}
