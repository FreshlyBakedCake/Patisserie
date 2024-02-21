#!/bin/sh

nix eval -f .sops.nix --apply "(f: f (builtins.getFlake \"nixpkgs\"))" --json > .sops.yaml # regenerate the "yaml" so you can add secrets