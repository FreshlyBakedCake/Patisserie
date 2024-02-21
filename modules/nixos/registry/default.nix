{ inputs, ... }: {
  nix.registry = inputs // {
    templates = "https://git.clicks.codes"; # nix init -t templates#typescript
  };
}