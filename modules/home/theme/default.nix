{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.chimera.theme = {
    cursor = null;
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
        Highlight = lib.mkOption { type = themeColor; };
      };
  };
}
