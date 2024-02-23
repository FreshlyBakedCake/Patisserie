{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    chimera.nixIndex.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables nix-index (from nix-index-database)";
      default = true;
      example = false;
    };

    chimera.nixIndex.comma.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables nix-community/comma";
      default = true;
      example = false;
    };
  };

  config = {
    xdg.enable = lib.mkIf config.chimera.nixIndex.enable true;

    programs.nix-index = {
      enable = config.chimera.nixIndex.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
      enableZshIntegration = config.chimera.shell.zsh.enable;
    };

    programs.nix-index-database.comma.enable = lib.mkIf config.chimera.nixIndex.enable config.chimera.nixIndex.comma.enable;
  };
}
