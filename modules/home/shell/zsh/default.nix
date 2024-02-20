{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.chimera.shell.zsh = {
    enable = lib.mkEnableOption "Enable ZSH Shell";
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
    dirHashes = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Attrset of ~DIR's";
      default = { };
    };
  };

  config = lib.mkIf config.chimera.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      defaultKeymap = "emacs";

      shellAliases = config.chimera.shell.zsh.extraAliases;

      dirHashes = config.chimera.shell.zsh.dirHashes;

      history = {
        extended = true;
      };
      historySubstringSearch.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };
  };
}
