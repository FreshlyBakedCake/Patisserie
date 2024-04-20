nixpkgs:
let
  keys = {
    users = {
      coded = "BC82DF237610AE9113EB075900E944BFBE99ADB5";
      minion = "76E0B09A741C4089522111E5F27E3E5922772E7A";
      pinea = "8F50789F12AC6E6206EA870CE5E1C2D43B0E4AB3";
    };
    hosts = {
      # nix run github:Mic92/ssh-to-pgp -- -i /etc/ssh/ssh_host_rsa_key
      shorthair = "B5237D6B63AB2E13FDA07170E5AED9775DD21543";
      greylag = "047bf8897df877fe86133e98522c6d280d545c00";
      saurosuchus = "12f47c96d9066c52897cdf9ddf581f86799fb07c";
    };
  };
in
{
  creation_rules = [
    {
      path_regex = ".*\\.sops\\.chimera\\.(yaml|json|env|ini|[^.]*\\.bin)$";
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.coded
        keys.users.minion
        keys.users.pinea

        keys.hosts.shorthair
        keys.hosts.greylag
        keys.hosts.saurosuchus
      ];
    }
    {
      path_regex = ".*\\.sops\\.coded\\.(yaml|json|env|ini|[^.]*\\.bin)$";
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.coded
        keys.hosts.shorthair
      ];
    }
    {
      path_regex = ".*\\.sops\\.minion\\.(yaml|json|env|ini|[^.]*\\.bin)$";
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.minion
        keys.hosts.greylag
      ];
    }
    {
      path_regex = ".*\\.sops\\.pinea\\.(yaml|json|env|ini|[^.]*\\.bin)$";
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.pinea
        keys.hosts.saurosuchus
      ];
    }
  ];
}
