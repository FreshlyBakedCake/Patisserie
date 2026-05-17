# SPDX-FileCopyrightText: 2025 FreshlyBakedCake
#
# SPDX-License-Identifier: MIT

let
  pins = import ./npins;

  nilla = import pins.nilla;

  settings = config: {
    nixpkgs = {
      configuration.allowUnfree = true;
      overlays = [
        config.inputs.fenix.result.overlays.default
      ];
    };
    "nixos-24.11" = (settings config).nixpkgs;
    nixos-unstable = (settings config).nixpkgs;
  };

  result = (nilla.create [ ]).extend {
    modules = [
      ./lib/project.nix
      ./menu/project.nix
      ./packetmix/project.nix
      ./sprinkles/project.nix
      ./nilla/project.nix
      (
        { config, ... }:
        {
          config.inputs =
            config.lib.attrs.generate (builtins.filter (name: name != "__functor") (builtins.attrNames pins))
              (name: {
                src = pins.${name};
                settings = (settings config).${name} or config.lib.constants.undefined;
              });
        }
      )
      (
        { config, ... }:
        {
          options.name = config.lib.options.create {
            description = "The names of all included subprojects";
            type = config.lib.types.coerce config.lib.types.string (val: [ val ]) (
              config.lib.types.list.of config.lib.types.string
            );
          };
        }
      )
    ];

    args = {
      inherit nilla pins; # pins needs to be a static arg for us to import from it...
    };
  };

  aliases =
    let
      ## Get all attrs with a prefix, returning a new attrset without that prefix. For example:
      ## selectPrefixedAttrs "abcd" { abcdefg = "adcdefg"; abcd = "abcd"; different = "different"; fooabcd = "fooabcd"; }
      ## -> { efg = "abcdefg"; "" = "abcd"; }
      selectPrefixedAttrs =
        lib: prefix: attrs:
        let
          attrNames = builtins.attrNames attrs;
          validNames = builtins.filter (lib.strings.hasPrefix prefix) attrNames;
          unprefixedNames = map (lib.strings.removePrefix prefix) validNames;
        in
        lib.attrs.generate unprefixedNames (name: attrs.${prefix + name});

      ## Given a list of attrsets, return a new attrset where any attributes that conflict with explicitly-specified attributes are removed, anything which is already defined is removed, and everything else is merged
      mergeNonduplicateAttrs =
        lib: attrsets: conflict:
        let
          attrCounts = builtins.foldl' (
            acc: elem: acc // (builtins.mapAttrs (name: _: (acc.${name} or 0) + 1) elem)
          ) { } attrsets;
          preservedAttrNames = builtins.filter (name: attrCounts.${name} == 1) (
            builtins.attrNames attrCounts
          );
          nonconflictingPreservedAttrNames = builtins.filter (
            name: !(builtins.hasAttr name conflict)
          ) preservedAttrNames;
          updatedAttrset = builtins.foldl' (acc: elem: acc // elem) { } attrsets;
        in
        lib.attrs.generate nonconflictingPreservedAttrNames (name: updatedAttrset.${name});
      aliased =
        config: old:
        mergeNonduplicateAttrs config.lib (builtins.map (
          name: selectPrefixedAttrs config.lib "${name}-" old
        ) config.name) old;
    in
    {
      homes = aliased result.config result.config.homes;
      packages = aliased result.config result.config.packages;
      shells = aliased result.config result.config.shells;
      systems.nixos = aliased result.config result.config.systems.nixos;
    };
in
(result.config.lib.attrs.mergeRecursive aliases result.config)
// {
  extend = result.extend;
  unalias = result.config // {
    extend = result.extend;
  };
}
