{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.emacs
    pkgs.neovim
    pkgs.vscode-fhs
  ];
}
