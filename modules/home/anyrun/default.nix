{ inputs, pkgs, system, ...}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${system}.applications
        inputs.anyrun.packages.${system}.rink
        inputs.anyrun.packages.${system}.shell
        inputs.anyrun.packages.${system}.translate
        inputs.anyrun.packages.${system}.kidex
        inputs.anyrun.packages.${system}.symbols
      ];
    };
  };
}