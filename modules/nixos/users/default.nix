{ pkgs, ... }: {
  users.users.minion = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = [
      pkgs.firefox
      pkgs.tree
    ];
    initialPassword = "nixos";
  };

  security.pam.services.waylock = {};
}
