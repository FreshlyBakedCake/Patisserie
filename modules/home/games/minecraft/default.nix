{ config, lib, pkgs, ... }: {
  options = {
    chimera.games.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft";
      launcher.package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.prismlauncher;
        example = pkgs.atlauncher;
      };
    };
  };

  config = {
    home.packages = lib.mkIf config.chimera.games.minecraft.enable [ config.chimera.games.minecraft.launcher.package ];
  };
}