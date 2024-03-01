{
  config,
  lib,
  pkgs,
  ...
}: let
  possibleEngines = [
    "Amazon"
    "Arch Wiki"
    "Bing"
    "Crates.io"
    "Docs.rs"
    "DuckDuckGo"
    "eBay"
    "Gentoo Wiki"
    "GitHub"
    "Google"
    "Home-Manager Options"
    "Kagi"
    "MDN"
    "NixOS Options"
    "NixOS Packages"
    "Noogle"
    "Wikipedia (en)"
  ];
in {
  options.chimera.browser.firefox.search = {
    enable = lib.mkEnableOption "Let Chimera control your firefox search engines";
    extensions.enable = lib.mkEnableOption "Install extensions relating to your chosen search engines";
    bookmarks.enable = lib.mkEnableOption "Add bookmarks to quickly jump to your chosen search engines. CAUTION: This option will overwrite (reset) any imperatively-added bookmarks";
    engines = lib.mkOption {
      type = lib.types.listOf (lib.types.enum possibleEngines);
      description = ''
        A list of search engines you want to enable. Any enabled engines will have the following Chimera customizations added:
        - They will be added to Firefox (if they are not already a default firefox search engine)
        - They will have an alias given[1], you can type "{alias} query" to search query with the engine
        - If you have enabled config.chimera.browser.firefox.search.installExtensions, they will have their respective extension
          installed (if one exists), e.g. enabling Kagi will install the Kagi extension for private browsing support[2]
        - If you have enabled config.chimera.browser.firefox.search.addBookmarks, they will have a shortcut added so you can type
          only "{alias}" and go to their homepage.

        The search engines will be ordered according to the order you give them in this list. The first one will be set as your
        default search engine.

        1:
          Amazon -> amazon
          Arch Wiki -> arch
          Bing -> bing
          Crates.io -> crates
          Docs.rs -> rs
          DuckDuckGo -> ddg
          eBay -> ebay
          Gentoo Wiki -> gentoo
          GitHub -> gh
          Google -> google
          Home-Manager Options -> hm
          Kagi -> kagi
          MDN -> mdn
          NixOS Options -> opts
          NixOS Packages -> pkgs
          Noogle -> lib
          Wikipedia (en) -> wiki
        2:
          DuckDuckGo installs https://addons.mozilla.org/en-US/firefox/addon/duckduckgo-for-firefox
          Kagi installs https://addons.mozilla.org/en-US/firefox/addon/kagi-search-for-firefox/
      '';
      default = [
        "DuckDuckGo"
        "MDN"
        "NixOS Options"
        "NixOS Packages"
        "Home-Manager Options"
        "Noogle"
        "GitHub"
        "Docs.rs"
        "Crates.io"
      ];
      example = [
        "Kagi"
        "MDN"
        "NixOS Options"
        "NixOS Packages"
        "Home-Manager Options"
        "Noogle"
        "GitHub"
        "Docs.rs"
        "Crates.io"
        "Arch Wiki"
        "Gentoo Wiki"
      ];
    };
  };

  config =
    let
      engineData = {
        "Amazon" = {
          homepage = "https://amazon.com";
          metaData.alias = "amazon";
        };
        "Arch Wiki" = {
          urls = [ { template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "arch" ];
          homepage = "https://wiki.archlinux.org/";
        };
        "Bing" = {
          homepage = "https://bing.com";
          metaData.alias = "bing";
        };
        "Crates.io" = {
          urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://crates.io/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "crates" ];
          homepage = "https://crates.io";
        };
        "Docs.rs" = {
          urls = [ { template = "https://docs.rs/releases/search?query={searchTerms}"; } ];
          iconUpdateURL = "https://docs.rs/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "rs" ];
          homepage = "https://docs.rs";
        };
        "DuckDuckGo" = {
          homepage = "https://duckduckgo.com";
          metaData.alias = "ddg";
          extraExtensions = [ config.nur.repos.rycee.firefox-addons.duckduckgo-privacy-essentials ];
        };
        "eBay" = {
          homepage = "https://ebay.com";
          metaData.alias = "ebay";
        };
        "Gentoo Wiki" = {
          urls = [ { template = "https://wiki.gentoo.org/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://www.gentoo.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "gentoo" ];
          homepage = "https://wiki.gentoo.org";
        };
        "GitHub" = {
          urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://github.com/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "gh" ];
          homepage = "https://github.com";
        };
        "Google" = {
          homepage = "https://google.com";
          metaData.alias = "google";
        };
        "Home-Manager Options" = {
          urls = [
            { template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}"; }
          ];
          iconUpdateURL = "https://mipmip.github.io/home-manager-option-search/images/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "hm" ];
          homepage = "https://mipmip.github.io/home-manager-option-search/";
        };
        "Kagi" = {
          urls = [
            { template = "https://kagi.com/search?q={searchTerms}"; }
            {
              template = "https://kagi.com/api/autosuggest?q={searchTerms}";
              type = "application/x-suggestions+json";
            }
          ];
          iconUpdateURL = "https://assets.kagi.com/v2/favicon-32x32.png";
          updateInterval = 24 * 60 * 60 * 1000;
          homepage = "https://kagi.com";
          definedAliases = [ "kagi" ];
          extraExtensions = [ config.nur.repos.rycee.firefox-addons.kagi-search ];
        };
        "MDN" = {
          urls = [ { template = "https://developer.mozilla.org/en-US/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://developer.mozilla.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          homepage = "https://developer.mozilla.org";
          definedAliases = [ "mdn" ];
        };
        "NixOS Options" = {
          urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
          iconUpdateURL = "https://nixos.org/logo/nix-wiki.png";
          updateInterval = 24 * 60 * 60 * 1000;
          homepage = "https://search.nixos.org/options?channel=unstable";
          definedAliases = [ "opts" ];
        };
        "NixOS Packages" = {
          urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
          iconUpdateURL = "https://nixos.org/logo/nix-wiki.png";
          updateInterval = 24 * 60 * 60 * 1000;
          homepage = "https://search.nixos.org/packages?channel=unstable";
          definedAliases = [ "pkgs" ];
        };
        "Noogle" = {
          urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
          iconUpdateURL = "https://noogle.dev/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          homepage = "https://noogle.dev";
          definedAliases = [ "lib" ];
        };
        "Wikipedia (en)" = {
          homepage = "https://en.wikipedia.org";
          metaData.alias = "wiki";
        };
      };
      calculated = lib.pipe engineData [
        (lib.filterAttrs (engine: _: builtins.elem engine config.chimera.browser.firefox.search.engines))
        (builtins.mapAttrs (
          name: value: {
            engines.${name} =
              lib.filterAttrs
                (
                  option: _:
                  !(builtins.elem option [
                    "homepage"
                    "extraExtensions"
                  ])
                )
                value;
            extensions = if builtins.hasAttr "extraExtensions" value then value.extraExtensions else [ ];
            bookmarks =
              if builtins.hasAttr "homepage" value then
                [
                  {
                    inherit name;
                    keyword = if builtins.hasAttr "definedAliases" value
                              then builtins.elemAt value.definedAliases 0
                              else value.metaData.alias;
                    url = value.homepage;
                  }
                ]
              else
                [ ];
          }
        ))
        builtins.attrValues
        (lib.zipAttrsWithNames ["engines" "extensions" "bookmarks"] (name: values: if name == "engines"
                                                                                   then lib.attrsets.mergeAttrsList values
                                                                                   else builtins.concatLists values))
      ];
      removedEngines = lib.pipe possibleEngines [
        (builtins.filter (engine: !(builtins.elem engine config.chimera.browser.firefox.search.engines)))
        (map (engine: {
          name = engine;
          value.metaData.hidden = true;
        }))
        builtins.listToAttrs
      ]; # We need to hide all the engines that we aren't selecting, because engines that we unset are not removed
    in
    lib.mkIf config.chimera.browser.firefox.search.enable {
      programs.firefox.profiles.chimera = {
        search = {
          engines = calculated.engines // removedEngines;
          order = config.chimera.browser.firefox.search.engines;
          default = lib.mkIf (builtins.length config.chimera.browser.firefox.search.engines > 0) (
            builtins.elemAt config.chimera.browser.firefox.search.engines 0
          );
          force = true;
        };
        extensions = lib.mkIf config.chimera.browser.firefox.search.extensions.enable calculated.extensions;
        bookmarks = lib.mkIf config.chimera.browser.firefox.search.bookmarks.enable calculated.bookmarks;
      };
    };
}
