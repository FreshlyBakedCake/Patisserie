nixpkgs: let
  keys = {
    users = {
      coded = "BC82DF237610AE9113EB075900E944BFBE99ADB5";
      minion = "76E0B09A741C4089522111E5F27E3E5922772E7A";
    };
    hosts = {
        shorthair = "B5237D6B63AB2E13FDA07170E5AED9775DD21543";
        greylag = "047bf8897df877fe86133e98522c6d280d545c00";
    };
};
in {
  creation_rules = [
    {
      path_regex = ''.*\.sops\.chimera\.(yaml|json|env|ini|[^.]*\.bin)$'';
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.coded
        keys.users.minion
        keys.hosts.shorthair
        keys.hosts.greylag
      ];
    }
    {
      path_regex = ''.*\.sops\.coded\.(yaml|json|env|ini|[^.]*\.bin)$'';
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.coded
        keys.hosts.shorthair
      ];
    }
    {
      path_regex = ''.*\.sops\.minion\.(yaml|json|env|ini|[^.]*\.bin)$'';
      pgp = nixpkgs.lib.concatStringsSep "," [
        keys.users.minion
        keys.hosts.greylag
      ];
    }
  ];
}