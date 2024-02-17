{ config, lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = config.chimera.shell.zsh.enable;
    enableBashIntegration = config.chimera.shell.bash.enable;
  };
}
