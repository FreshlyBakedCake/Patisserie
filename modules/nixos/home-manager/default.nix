{ inputs, system, ... }:
{
  environment.systemPackages = [ inputs.home-manager.defaultPackage.${system} ];
}
