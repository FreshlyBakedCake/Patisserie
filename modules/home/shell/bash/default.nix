{ config, lib, ... }:
{
  options.chimera.shell.bash = {
    enable = lib.mkEnableOption "Enable Bash Shell";
    default = lib.mkOption {
      type = lib.types.bool;
      description = "Set as default shell";
      default = true;
    };
    extraAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Attrset of extra shell aliases";
      default = { };
    };
  };

  config = lib.mkIf config.chimera.shell.bash.enable {
    programs.bash = {
      enable = true;

      shellAliases = config.chimera.shell.bash.extraAliases;
    };
  };
}
