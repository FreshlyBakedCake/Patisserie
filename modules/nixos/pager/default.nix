{ pkgs, ... }: {
  environment.variables.PAGER = "${pkgs.less}/bin/less -R";
}
