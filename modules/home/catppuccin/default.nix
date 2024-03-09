{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.chimera.theme.catppuccin = {
    enable = lib.mkEnableOption "Whether to use Catppuccin themes";
    style = lib.mkOption {
      type = lib.types.enum [
        "Latte"
        "Frappe"
        "Macchiato"
        "Mocha"
      ];
      description = "Catppuccin style to use";
    };
    color = lib.mkOption {
      type = lib.types.enum [
        "Rosewater"
        "Flamingo"
        "Pink"
        "Mauve"
        "Red"
        "Maroon"
        "Peach"
        "Yellow"
        "Green"
        "Teal"
        "Sky"
        "Sapphire"
        "Blue"
        "Lavender"
        "Text"
        "Subtext1"
        "Subtext0"
        "Overlay2"
        "Overlay1"
        "Overlay0"
        "Surface2"
        "Surface1"
        "Surface0"
        "Base"
        "Mantle"
        "Crust"
      ];
      description = "Catppuccin color to use";
    };
  };

  config = lib.mkIf config.chimera.theme.catppuccin.enable (
    let
      catppuccinColors = {
        Latte = {
          Rosewater = {
            hex = "dc8a78";
            rgb = {
              r = 220;
              g = 138;
              b = 120;
            };
            hsl = {
              h = 11;
              s = 59;
              l = 67;
            };
          };
          Flamingo = {
            hex = "dd7878";
            rgb = {
              r = 221;
              g = 120;
              b = 120;
            };
            hsl = {
              h = 0;
              s = 60;
              l = 67;
            };
          };
          Pink = {
            hex = "ea76cb";
            rgb = {
              r = 234;
              g = 118;
              b = 203;
            };
            hsl = {
              h = 316;
              s = 73;
              l = 69;
            };
          };
          Mauve = {
            hex = "8839ef";
            rgb = {
              r = 136;
              g = 57;
              b = 239;
            };
            hsl = {
              h = 266;
              s = 85;
              l = 58;
            };
          };
          Red = {
            hex = "d20f39";
            rgb = {
              r = 210;
              g = 15;
              b = 57;
            };
            hsl = {
              h = 347;
              s = 87;
              l = 44;
            };
          };
          Maroon = {
            hex = "e64553";
            rgb = {
              r = 230;
              g = 69;
              b = 83;
            };
            hsl = {
              h = 355;
              s = 76;
              l = 59;
            };
          };
          Peach = {
            hex = "fe640b";
            rgb = {
              r = 254;
              g = 100;
              b = 11;
            };
            hsl = {
              h = 22;
              s = 99;
              l = 52;
            };
          };
          Yellow = {
            hex = "df8e1d";
            rgb = {
              r = 223;
              g = 142;
              b = 29;
            };
            hsl = {
              h = 35;
              s = 77;
              l = 49;
            };
          };
          Green = {
            hex = "40a02b";
            rgb = {
              r = 64;
              g = 160;
              b = 43;
            };
            hsl = {
              h = 109;
              s = 58;
              l = 40;
            };
          };
          Teal = {
            hex = "179299";
            rgb = {
              r = 23;
              g = 146;
              b = 153;
            };
            hsl = {
              h = 183;
              s = 74;
              l = 35;
            };
          };
          Sky = {
            hex = "04a5e5";
            rgb = {
              r = 4;
              g = 165;
              b = 229;
            };
            hsl = {
              h = 197;
              s = 97;
              l = 46;
            };
          };
          Sapphire = {
            hex = "209fb5";
            rgb = {
              r = 32;
              g = 159;
              b = 181;
            };
            hsl = {
              h = 189;
              s = 70;
              l = 42;
            };
          };
          Blue = {
            hex = "1e66f5";
            rgb = {
              r = 30;
              g = 102;
              b = 245;
            };
            hsl = {
              h = 220;
              s = 91;
              l = 54;
            };
          };
          Lavender = {
            hex = "7287fd";
            rgb = {
              r = 114;
              g = 135;
              b = 253;
            };
            hsl = {
              h = 231;
              s = 97;
              l = 72;
            };
          };
          Text = {
            hex = "4c4f69";
            rgb = {
              r = 76;
              g = 79;
              b = 105;
            };
            hsl = {
              h = 234;
              s = 16;
              l = 35;
            };
          };
          Subtext1 = {
            hex = "5c5f77";
            rgb = {
              r = 92;
              g = 95;
              b = 119;
            };
            hsl = {
              h = 233;
              s = 13;
              l = 41;
            };
          };
          Subtext0 = {
            hex = "6c6f85";
            rgb = {
              r = 108;
              g = 111;
              b = 133;
            };
            hsl = {
              h = 233;
              s = 10;
              l = 47;
            };
          };
          Overlay2 = {
            hex = "7c7f93";
            rgb = {
              r = 124;
              g = 127;
              b = 147;
            };
            hsl = {
              h = 232;
              s = 10;
              l = 53;
            };
          };
          Overlay1 = {
            hex = "8c8fa1";
            rgb = {
              r = 140;
              g = 143;
              b = 161;
            };
            hsl = {
              h = 231;
              s = 10;
              l = 59;
            };
          };
          Overlay0 = {
            hex = "9ca0b0";
            rgb = {
              r = 156;
              g = 160;
              b = 176;
            };
            hsl = {
              h = 228;
              s = 11;
              l = 65;
            };
          };
          Surface2 = {
            hex = "acb0be";
            rgb = {
              r = 172;
              g = 176;
              b = 190;
            };
            hsl = {
              h = 227;
              s = 12;
              l = 71;
            };
          };
          Surface1 = {
            hex = "bcc0cc";
            rgb = {
              r = 188;
              g = 192;
              b = 204;
            };
            hsl = {
              h = 225;
              s = 14;
              l = 77;
            };
          };
          Surface0 = {
            hex = "ccd0da";
            rgb = {
              r = 204;
              g = 208;
              b = 218;
            };
            hsl = {
              h = 223;
              s = 16;
              l = 83;
            };
          };
          Base = {
            hex = "eff1f5";
            rgb = {
              r = 239;
              g = 241;
              b = 245;
            };
            hsl = {
              h = 220;
              s = 23;
              l = 95;
            };
          };
          Mantle = {
            hex = "e6e9ef";
            rgb = {
              r = 230;
              g = 233;
              b = 239;
            };
            hsl = {
              h = 220;
              s = 22;
              l = 92;
            };
          };
          Crust = {
            hex = "dce0e8";
            rgb = {
              r = 220;
              g = 224;
              b = 232;
            };
            hsl = {
              h = 220;
              s = 21;
              l = 89;
            };
          };
        };
        Frappe = {
          Rosewater = {
            hex = "f2d5cf";
            rgb = {
              r = 242;
              g = 213;
              b = 207;
            };
            hsl = {
              h = 10;
              s = 57;
              l = 88;
            };
          };
          Flamingo = {
            hex = "eebebe";
            rgb = {
              r = 238;
              g = 190;
              b = 190;
            };
            hsl = {
              h = 0;
              s = 59;
              l = 84;
            };
          };
          Pink = {
            hex = "f4b8e4";
            rgb = {
              r = 244;
              g = 184;
              b = 228;
            };
            hsl = {
              h = 316;
              s = 73;
              l = 84;
            };
          };
          Mauve = {
            hex = "ca9ee6";
            rgb = {
              r = 202;
              g = 158;
              b = 230;
            };
            hsl = {
              h = 277;
              s = 59;
              l = 76;
            };
          };
          Red = {
            hex = "e78284";
            rgb = {
              r = 231;
              g = 130;
              b = 132;
            };
            hsl = {
              h = 359;
              s = 68;
              l = 71;
            };
          };
          Maroon = {
            hex = "ea999c";
            rgb = {
              r = 234;
              g = 153;
              b = 156;
            };
            hsl = {
              h = 358;
              s = 66;
              l = 76;
            };
          };
          Peach = {
            hex = "ef9f76";
            rgb = {
              r = 239;
              g = 159;
              b = 118;
            };
            hsl = {
              h = 20;
              s = 79;
              l = 70;
            };
          };
          Yellow = {
            hex = "e5c890";
            rgb = {
              r = 229;
              g = 200;
              b = 144;
            };
            hsl = {
              h = 40;
              s = 62;
              l = 73;
            };
          };
          Green = {
            hex = "a6d189";
            rgb = {
              r = 166;
              g = 209;
              b = 137;
            };
            hsl = {
              h = 96;
              s = 44;
              l = 68;
            };
          };
          Teal = {
            hex = "81c8be";
            rgb = {
              r = 129;
              g = 200;
              b = 190;
            };
            hsl = {
              h = 172;
              s = 39;
              l = 65;
            };
          };
          Sky = {
            hex = "99d1db";
            rgb = {
              r = 153;
              g = 209;
              b = 219;
            };
            hsl = {
              h = 189;
              s = 48;
              l = 73;
            };
          };
          Sapphire = {
            hex = "85c1dc";
            rgb = {
              r = 133;
              g = 193;
              b = 220;
            };
            hsl = {
              h = 199;
              s = 55;
              l = 69;
            };
          };
          Blue = {
            hex = "8caaee";
            rgb = {
              r = 140;
              g = 170;
              b = 238;
            };
            hsl = {
              h = 222;
              s = 74;
              l = 74;
            };
          };
          Lavender = {
            hex = "babbf1";
            rgb = {
              r = 186;
              g = 187;
              b = 241;
            };
            hsl = {
              h = 239;
              s = 66;
              l = 84;
            };
          };
          Text = {
            hex = "c6d0f5";
            rgb = {
              r = 198;
              g = 208;
              b = 245;
            };
            hsl = {
              h = 227;
              s = 70;
              l = 87;
            };
          };
          Subtext1 = {
            hex = "b5bfe2";
            rgb = {
              r = 181;
              g = 191;
              b = 226;
            };
            hsl = {
              h = 227;
              s = 44;
              l = 80;
            };
          };
          Subtext0 = {
            hex = "a5adce";
            rgb = {
              r = 165;
              g = 173;
              b = 206;
            };
            hsl = {
              h = 228;
              s = 29;
              l = 73;
            };
          };
          Overlay2 = {
            hex = "949cbb";
            rgb = {
              r = 148;
              g = 156;
              b = 187;
            };
            hsl = {
              h = 228;
              s = 22;
              l = 66;
            };
          };
          Overlay1 = {
            hex = "838ba7";
            rgb = {
              r = 131;
              g = 139;
              b = 167;
            };
            hsl = {
              h = 227;
              s = 17;
              l = 58;
            };
          };
          Overlay0 = {
            hex = "737994";
            rgb = {
              r = 115;
              g = 121;
              b = 148;
            };
            hsl = {
              h = 229;
              s = 13;
              l = 52;
            };
          };
          Surface2 = {
            hex = "626880";
            rgb = {
              r = 98;
              g = 104;
              b = 128;
            };
            hsl = {
              h = 228;
              s = 13;
              l = 44;
            };
          };
          Surface1 = {
            hex = "51576d";
            rgb = {
              r = 81;
              g = 87;
              b = 109;
            };
            hsl = {
              h = 227;
              s = 15;
              l = 37;
            };
          };
          Surface0 = {
            hex = "414559";
            rgb = {
              r = 65;
              g = 69;
              b = 89;
            };
            hsl = {
              h = 230;
              s = 16;
              l = 30;
            };
          };
          Base = {
            hex = "303446";
            rgb = {
              r = 48;
              g = 52;
              b = 70;
            };
            hsl = {
              h = 229;
              s = 19;
              l = 23;
            };
          };
          Mantle = {
            hex = "292c3c";
            rgb = {
              r = 41;
              g = 44;
              b = 60;
            };
            hsl = {
              h = 231;
              s = 19;
              l = 20;
            };
          };
          Crust = {
            hex = "232634";
            rgb = {
              r = 35;
              g = 38;
              b = 52;
            };
            hsl = {
              h = 229;
              s = 20;
              l = 17;
            };
          };
        };
        Macchiato = {
          Rosewater = {
            hex = "f4dbd6";
            rgb = {
              r = 244;
              g = 219;
              b = 214;
            };
            hsl = {
              h = 10;
              s = 58;
              l = 90;
            };
          };
          Flamingo = {
            hex = "f0c6c6";
            rgb = {
              r = 240;
              g = 198;
              b = 198;
            };
            hsl = {
              h = 0;
              s = 58;
              l = 86;
            };
          };
          Pink = {
            hex = "f5bde6";
            rgb = {
              r = 245;
              g = 189;
              b = 230;
            };
            hsl = {
              h = 316;
              s = 74;
              l = 85;
            };
          };
          Mauve = {
            hex = "c6a0f6";
            rgb = {
              r = 198;
              g = 160;
              b = 246;
            };
            hsl = {
              h = 267;
              s = 83;
              l = 80;
            };
          };
          Red = {
            hex = "ed8796";
            rgb = {
              r = 237;
              g = 135;
              b = 150;
            };
            hsl = {
              h = 351;
              s = 74;
              l = 73;
            };
          };
          Maroon = {
            hex = "ee99a0";
            rgb = {
              r = 238;
              g = 153;
              b = 160;
            };
            hsl = {
              h = 355;
              s = 71;
              l = 77;
            };
          };
          Peach = {
            hex = "f5a97f";
            rgb = {
              r = 245;
              g = 169;
              b = 127;
            };
            hsl = {
              h = 21;
              s = 86;
              l = 73;
            };
          };
          Yellow = {
            hex = "eed49f";
            rgb = {
              r = 238;
              g = 212;
              b = 159;
            };
            hsl = {
              h = 40;
              s = 70;
              l = 78;
            };
          };
          Green = {
            hex = "a6da95";
            rgb = {
              r = 166;
              g = 218;
              b = 149;
            };
            hsl = {
              h = 105;
              s = 48;
              l = 72;
            };
          };
          Teal = {
            hex = "8bd5ca";
            rgb = {
              r = 139;
              g = 213;
              b = 202;
            };
            hsl = {
              h = 171;
              s = 47;
              l = 69;
            };
          };
          Sky = {
            hex = "91d7e3";
            rgb = {
              r = 145;
              g = 215;
              b = 227;
            };
            hsl = {
              h = 189;
              s = 59;
              l = 73;
            };
          };
          Sapphire = {
            hex = "7dc4e4";
            rgb = {
              r = 125;
              g = 196;
              b = 228;
            };
            hsl = {
              h = 199;
              s = 66;
              l = 69;
            };
          };
          Blue = {
            hex = "8aadf4";
            rgb = {
              r = 138;
              g = 173;
              b = 244;
            };
            hsl = {
              h = 220;
              s = 83;
              l = 75;
            };
          };
          Lavender = {
            hex = "b7bdf8";
            rgb = {
              r = 183;
              g = 189;
              b = 248;
            };
            hsl = {
              h = 234;
              s = 82;
              l = 85;
            };
          };
          Text = {
            hex = "cad3f5";
            rgb = {
              r = 202;
              g = 211;
              b = 245;
            };
            hsl = {
              h = 227;
              s = 68;
              l = 88;
            };
          };
          Subtext1 = {
            hex = "b8c0e0";
            rgb = {
              r = 184;
              g = 192;
              b = 224;
            };
            hsl = {
              h = 228;
              s = 39;
              l = 80;
            };
          };
          Subtext0 = {
            hex = "a5adcb";
            rgb = {
              r = 165;
              g = 173;
              b = 203;
            };
            hsl = {
              h = 227;
              s = 27;
              l = 72;
            };
          };
          Overlay2 = {
            hex = "939ab7";
            rgb = {
              r = 147;
              g = 154;
              b = 183;
            };
            hsl = {
              h = 228;
              s = 20;
              l = 65;
            };
          };
          Overlay1 = {
            hex = "8087a2";
            rgb = {
              r = 128;
              g = 135;
              b = 162;
            };
            hsl = {
              h = 228;
              s = 15;
              l = 57;
            };
          };
          Overlay0 = {
            hex = "6e738d";
            rgb = {
              r = 110;
              g = 115;
              b = 141;
            };
            hsl = {
              h = 230;
              s = 12;
              l = 49;
            };
          };
          Surface2 = {
            hex = "5b6078";
            rgb = {
              r = 91;
              g = 96;
              b = 120;
            };
            hsl = {
              h = 230;
              s = 14;
              l = 41;
            };
          };
          Surface1 = {
            hex = "494d64";
            rgb = {
              r = 73;
              g = 77;
              b = 100;
            };
            hsl = {
              h = 231;
              s = 16;
              l = 34;
            };
          };
          Surface0 = {
            hex = "363a4f";
            rgb = {
              r = 54;
              g = 58;
              b = 79;
            };
            hsl = {
              h = 230;
              s = 19;
              l = 26;
            };
          };
          Base = {
            hex = "24273a";
            rgb = {
              r = 36;
              g = 39;
              b = 58;
            };
            hsl = {
              h = 232;
              s = 23;
              l = 18;
            };
          };
          Mantle = {
            hex = "1e2030";
            rgb = {
              r = 30;
              g = 32;
              b = 48;
            };
            hsl = {
              h = 233;
              s = 23;
              l = 15;
            };
          };
          Crust = {
            hex = "181926";
            rgb = {
              r = 24;
              g = 25;
              b = 38;
            };
            hsl = {
              h = 236;
              s = 23;
              l = 12;
            };
          };
        };
        Mocha = {
          Rosewater = {
            hex = "f5e0dc";
            rgb = {
              r = 245;
              g = 224;
              b = 220;
            };
            hsl = {
              h = 10;
              s = 56;
              l = 91;
            };
          };
          Flamingo = {
            hex = "f2cdcd";
            rgb = {
              r = 242;
              g = 205;
              b = 205;
            };
            hsl = {
              h = 0;
              s = 59;
              l = 88;
            };
          };
          Pink = {
            hex = "f5c2e7";
            rgb = {
              r = 245;
              g = 194;
              b = 231;
            };
            hsl = {
              h = 316;
              s = 72;
              l = 86;
            };
          };
          Mauve = {
            hex = "cba6f7";
            rgb = {
              r = 203;
              g = 166;
              b = 247;
            };
            hsl = {
              h = 267;
              s = 84;
              l = 81;
            };
          };
          Red = {
            hex = "f38ba8";
            rgb = {
              r = 243;
              g = 139;
              b = 168;
            };
            hsl = {
              h = 343;
              s = 81;
              l = 75;
            };
          };
          Maroon = {
            hex = "eba0ac";
            rgb = {
              r = 235;
              g = 160;
              b = 172;
            };
            hsl = {
              h = 350;
              s = 65;
              l = 77;
            };
          };
          Peach = {
            hex = "fab387";
            rgb = {
              r = 250;
              g = 179;
              b = 135;
            };
            hsl = {
              h = 23;
              s = 92;
              l = 75;
            };
          };
          Yellow = {
            hex = "f9e2af";
            rgb = {
              r = 249;
              g = 226;
              b = 175;
            };
            hsl = {
              h = 41;
              s = 86;
              l = 83;
            };
          };
          Green = {
            hex = "a6e3a1";
            rgb = {
              r = 166;
              g = 227;
              b = 161;
            };
            hsl = {
              h = 115;
              s = 54;
              l = 76;
            };
          };
          Teal = {
            hex = "94e2d5";
            rgb = {
              r = 148;
              g = 226;
              b = 213;
            };
            hsl = {
              h = 170;
              s = 57;
              l = 73;
            };
          };
          Sky = {
            hex = "89dceb";
            rgb = {
              r = 137;
              g = 220;
              b = 235;
            };
            hsl = {
              h = 189;
              s = 71;
              l = 73;
            };
          };
          Sapphire = {
            hex = "74c7ec";
            rgb = {
              r = 116;
              g = 199;
              b = 236;
            };
            hsl = {
              h = 199;
              s = 76;
              l = 69;
            };
          };
          Blue = {
            hex = "89b4fa";
            rgb = {
              r = 137;
              g = 180;
              b = 250;
            };
            hsl = {
              h = 217;
              s = 92;
              l = 76;
            };
          };
          Lavender = {
            hex = "b4befe";
            rgb = {
              r = 180;
              g = 190;
              b = 254;
            };
            hsl = {
              h = 232;
              s = 97;
              l = 85;
            };
          };
          Text = {
            hex = "cdd6f4";
            rgb = {
              r = 205;
              g = 214;
              b = 244;
            };
            hsl = {
              h = 226;
              s = 64;
              l = 88;
            };
          };
          Subtext1 = {
            hex = "bac2de";
            rgb = {
              r = 186;
              g = 194;
              b = 222;
            };
            hsl = {
              h = 227;
              s = 35;
              l = 80;
            };
          };
          Subtext0 = {
            hex = "a6adc8";
            rgb = {
              r = 166;
              g = 173;
              b = 200;
            };
            hsl = {
              h = 228;
              s = 24;
              l = 72;
            };
          };
          Overlay2 = {
            hex = "9399b2";
            rgb = {
              r = 147;
              g = 153;
              b = 178;
            };
            hsl = {
              h = 228;
              s = 17;
              l = 64;
            };
          };
          Overlay1 = {
            hex = "7f849c";
            rgb = {
              r = 127;
              g = 132;
              b = 156;
            };
            hsl = {
              h = 230;
              s = 13;
              l = 55;
            };
          };
          Overlay0 = {
            hex = "6c7086";
            rgb = {
              r = 108;
              g = 112;
              b = 134;
            };
            hsl = {
              h = 231;
              s = 11;
              l = 47;
            };
          };
          Surface2 = {
            hex = "585b70";
            rgb = {
              r = 88;
              g = 91;
              b = 112;
            };
            hsl = {
              h = 233;
              s = 12;
              l = 39;
            };
          };
          Surface1 = {
            hex = "45475a";
            rgb = {
              r = 69;
              g = 71;
              b = 90;
            };
            hsl = {
              h = 234;
              s = 13;
              l = 31;
            };
          };
          Surface0 = {
            hex = "313244";
            rgb = {
              r = 49;
              g = 50;
              b = 68;
            };
            hsl = {
              h = 237;
              s = 16;
              l = 23;
            };
          };
          Base = {
            hex = "1e1e2e";
            rgb = {
              r = 30;
              g = 30;
              b = 46;
            };
            hsl = {
              h = 240;
              s = 21;
              l = 15;
            };
          };
          Mantle = {
            hex = "181825";
            rgb = {
              r = 24;
              g = 24;
              b = 37;
            };
            hsl = {
              h = 240;
              s = 21;
              l = 12;
            };
          };
          Crust = {
            hex = "11111b";
            rgb = {
              r = 17;
              g = 17;
              b = 27;
            };
            hsl = {
              h = 240;
              s = 23;
              l = 9;
            };
          };
        };
      };
    in
    {
      chimera.theme = {
        colors = catppuccinColors.${config.chimera.theme.catppuccin.style} // {
          Accent =
            catppuccinColors.${config.chimera.theme.catppuccin.style}.${config.chimera.theme.catppuccin.color};
        };

        style = if config.chimera.theme.catppuccin.style == "Latte" then "Light" else "Dark";

        cursor = {
          package =
            pkgs.catppuccin-cursors."${lib.strings.toLower config.chimera.theme.catppuccin.style}${config.chimera.theme.catppuccin.color}";
          name = "Catppuccin-${config.chimera.theme.catppuccin.style}-${config.chimera.theme.catppuccin.color}-Cursors";
          size = 32;
        };
      };
    }
  );
}
