{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options.chimera.theme = {
    font = {
      mono = lib.mkOption {
        type = inputs.home-manager.lib.hm.types.fontType;
        description = "Mono width font to use as system default";
        default = {
          name = "FiraCode";
          package = pkgs.fira-code;
          size = 12;
        };
      };
      variableWidth = {
        serif = lib.mkOption {
          type = inputs.home-manager.lib.hm.types.fontType;
          description = "Serif variable width font to use as system default";
          default = {
            name = "Roboto Serif";
            package = pkgs.roboto-serif;
            size = 12;
          };
        };
        sansSerif = lib.mkOption {
          type = inputs.home-manager.lib.hm.types.fontType;
          description = "Sans serif variable width font to use as system default";
          default = {
            name = "Roboto";
            package = pkgs.roboto;
            size = 12;
          };
        };
      };
      emoji = lib.mkOption {
        type = inputs.home-manager.lib.hm.types.fontType;
        description = "Emoji's to use as system default";
        default = {
          name = "Twitter Color Emoji";
          package = pkgs.twitter-color-emoji;
          size = 12;
        };
      };
      nerdFontGlyphs.enable = lib.mkEnableOption "Enable Nerd Font Glyphs";
      extraFonts = lib.mkOption {
        type = lib.types.listOf inputs.home-manager.lib.hm.types.fontType;
        description = "Extra fonts to install";
        default = [ ];
      };
    };

    cursor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
              example = lib.literalExpression "pkgs.vanilla-dmz";
              description = "Package providing the cursor theme";
            };

            name = lib.mkOption {
              type = lib.types.str;
              example = "Vanilla-DMZ";
              description = "The cursor name within the package";
            };

            size = lib.mkOption {
              type = lib.types.int;
              default = 32;
              example = 64;
              description = "The cursor size";
            };
          };
        }
      );
      description = "Cursor settings";
      default = null;
    };

    colors =
      let
        themeColor = {
          hex = lib.types.str;
          rgb = {
            r = lib.types.numbers 0 255;
            g = lib.types.numbers 0 255;
            b = lib.types.numbers 0 255;
          };
          hsl = {
            h = lib.types.numbers 0 360;
            s = lib.types.numbers 0 100;
            l = lib.types.numbers 0 100;
          };
        };
      in
      {
        Rosewater = lib.mkOption { type = themeColor; };
        Flamingo = lib.mkOption { type = themeColor; };
        Pink = lib.mkOption { type = themeColor; };
        Mauve = lib.mkOption { type = themeColor; };
        Red = lib.mkOption { type = themeColor; };
        Maroon = lib.mkOption { type = themeColor; };
        Peach = lib.mkOption { type = themeColor; };
        Yellow = lib.mkOption { type = themeColor; };
        Green = lib.mkOption { type = themeColor; };
        Teal = lib.mkOption { type = themeColor; };
        Sky = lib.mkOption { type = themeColor; };
        Sapphire = lib.mkOption { type = themeColor; };
        Blue = lib.mkOption { type = themeColor; };
        Lavender = lib.mkOption { type = themeColor; };
        Text = lib.mkOption { type = themeColor; };
        Subtext1 = lib.mkOption { type = themeColor; };
        Subtext0 = lib.mkOption { type = themeColor; };
        Overlay2 = lib.mkOption { type = themeColor; };
        Overlay1 = lib.mkOption { type = themeColor; };
        Overlay0 = lib.mkOption { type = themeColor; };
        Surface2 = lib.mkOption { type = themeColor; };
        Surface1 = lib.mkOption { type = themeColor; };
        Surface0 = lib.mkOption { type = themeColor; };
        Base = lib.mkOption { type = themeColor; };
        Mantle = lib.mkOption { type = themeColor; };
        Crust = lib.mkOption { type = themeColor; };
        Accent = lib.mkOption { type = themeColor; };
      };
  };

  config = {

    fonts.fontconfig.enable = true;

    home.packages =
      [
        config.chimera.theme.font.mono.package
        config.chimera.theme.font.variableWidth.serif.package
        config.chimera.theme.font.variableWidth.sansSerif.package
        config.chimera.theme.font.emoji.package
      ]
      ++ (
        if config.chimera.theme.font.nerdFontGlyphs.enable then
          [ (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; }) ]
        else
          [ ]
      )
      ++ config.chimera.theme.font.extraFonts;

    home.pointerCursor = lib.mkIf (config.chimera.theme.cursor != null) {
      name = config.chimera.theme.cursor.name;
      package = config.chimera.theme.cursor.package;
      size = config.chimera.theme.cursor.size;
      gtk.enable = true; # TODO: should we factor this out into a gtk module when we come to that?
      x11.enable = true;
    };
  };
}
