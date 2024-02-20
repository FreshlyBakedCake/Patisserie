{ pkgs, ... }: {
    programs.zsh.enable = true;

    users.users.minion.shell = pkgs.bashInteractive;
    users.users.coded.shell = pkgs.zsh;
}