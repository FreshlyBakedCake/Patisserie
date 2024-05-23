/*
This file is modified from https://github.com/Andrey0189/hyprland-rice/blob/main/config/waybar/config
As such you can access it under the following license terms:

MIT License

Copyright (c) 2024 Andrew

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
{ config, lib, pkgs, ... }: {
  options.chimera.waybar = {
    enable = lib.mkEnableOption "Enable Waybar";
    modules = {
      laptop.enable = lib.mkEnableOption "Enable all laptop modules by default";
      backlight = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.chimera.waybar.modules.laptop.enable;
          description = "Enable reading and modifying backlight using light";
        };
      };
      battery = {
        states = {
          full = lib.mkOption {
            type = lib.types.int;
            default = 98;
            description = "The power above which your battery will be considered full";
          };
          warning = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "The power below which your battery will be considered at 'low' levels";
          };
          critical = lib.mkOption {
            type = lib.types.int;
            default = 15;
            description = "The power below which your battery will be considered critically low";
          };
        };
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.chimera.waybar.modules.laptop.enable;
          description = "Enable battery module";
        };
      };
      temperature = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.chimera.waybar.modules.temperature.hwmonPath != null;
          description = "Enable temperature module";
        };
        hwmonPath = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "System CPU hardware temperature path";
          example = "/sys/class/hwmon/hwmon1/temp1_input";
          default = null;
        };
      };
    };
  };

  config = {
    programs.waybar = lib.mkIf config.chimera.waybar.enable {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          margin = "9 13 -10 18";
          modules-left = (if config.chimera.hyprland.enable then ["hyprland/workspaces"] else []);
          modules-center = ["clock"];
          modules-right = ["pulseaudio" "custom/mem" "cpu"]
            ++ (if config.chimera.waybar.modules.temperature.enable then [ "temperature" ] else [])
            ++ (if config.chimera.waybar.modules.battery.enable then [ "backlight" ] else [])
            ++ (if config.chimera.waybar.modules.battery.enable then [ "battery" ] else [])
            ++ [ "tray" ];

          "hyprland/workspaces" = lib.mkIf config.chimera.hyprland.enable {
            "disable-scroll" = true;
          };
          clock = {
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format" = "{:%a, %d %b, %I:%M %p}";
          };
          pulseaudio = {
            "scroll-step" = 1;
            "reverse-scrolling" = 1;
            "format" = "{volume}% {icon} {format_source}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
                "headphone" = "";
                "hands-free" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = ["" "" ""];
            };
            "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
            "min-length" = 13;
          };
          "custom/mem" = {
            "format" = "{} ɤ";
            "interval" = 5;
            "exec" = "free -h | awk '/Mem:/{printf $3}'";
            "tooltip" = false;
          };
          cpu = {
            "interval" = 2;
            "format" = "{usage}% ";
            "min-length" = 6;
          };
          temperature = {
            "thermal-zone" = 2;
            "hwmon-path" = config.chimera.waybar.modules.temperature.hwmonPath;
            "critical-threshold" = 80;
            "format-critical" = "{temperatureC}°C {icon}";
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = ["" "" "" "" ""];
            "tooltip" = false;
            "interval" = 2;
          };
          backlight = lib.mkIf config.chimera.waybar.modules.backlight.enable {
            "format" = "{percent}% {icon}";
            "format-icons" = [""];
            "min-length" = 7;
          };
          battery = lib.mkIf config.chimera.waybar.modules.battery.enable {
            "states" = config.chimera.waybar.modules.battery.states;
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" "" ""];
            "on-update" = "$HOME/.config/waybar/scripts/check_battery.sh";
          };
          tray = {
            "icon-size" = 16;
            "spacing" = 0;
          };
        }
      ];
      style = ''
        @define-color background #${config.chimera.theme.colors.Crust.hex};
        @define-color active #${config.chimera.theme.colors.Accent.hex};
        @define-color hover #${config.chimera.theme.colors.Surface2.hex};
        @define-color text #${config.chimera.theme.colors.Text.hex};
        @define-color altText #${config.chimera.theme.colors.Base.hex};
        @define-color critical #${config.chimera.theme.colors.Red.hex};
        @define-color warning #${config.chimera.theme.colors.Yellow.hex};
        @define-color charging #${config.chimera.theme.colors.Green.hex};
      '' + builtins.readFile ./main.css;
    };
  };
}