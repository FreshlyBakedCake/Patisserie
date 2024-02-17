{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}:
let
  lock = "${pkgs.waylock}/bin/waylock";
in
{
  options.chimera = {
    input.mouse.scrolling.natural = lib.mkEnableOption "Enable natural scrolling";
    input.touchpad.scrolling.natural = lib.mkOption {
      type = lib.types.bool;
      description = "Enable natural scrolling";
      default = config.chimera.input.mouse.scrolling.natural;
    };
    input.keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        description = "Keyboard layouts, comma seperated";
        example = "us,de";
        default = "us";
      };
      variant = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Keyboard layout variants, comma seperated";
        example = "dvorak";
        default = null;
      };
    };
    hyprland = {
      enable = lib.mkEnableOption "Use hyprland as your window manager";

      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of default monitors to set";
        default = [ ];
      };
    };
  };

  # TODO: Eww, SwayNC, hyprland-per-window-layout, waylock, hy3, anyrun, hypr-empty

  config = lib.mkIf config.chimera.hyprland.enable {
    home.packages = [ pkgs.hyprpicker ];

    services.fusuma.settings.swipe = lib.mkIf config.chimera.touchpad.enable (
      let
        hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        jq = "${pkgs.jq}/bin/jq";
        awk = "${pkgs.gawk}/bin/awk";
      in
      {
        "3".up.command = "${hyprctl} dispatch fullscreen 0";
        "3".down.command = "${hyprctl} dispatch fullscreen 0";
        "4".down.command = lock;
        "3".left.command = "${hyprctl} dispatch workspace $(${hyprctl} activeworkspace -j | ${jq} .id | ${awk} '{print $1+1}')";
        "3".right.command = "${hyprctl} dispatch workspace $(${hyprctl} activeworkspace -j | ${jq} .id | ${awk} '{print $1-1}')";
      }
    );

    wayland.windowManager.hyprland = {
      enable = true;

      xwayland.enable = true;
      systemd.enable = true;

      settings =
        let
          mod = "SUPER";
          terminal = "${pkgs.kitty}/bin/kitty";
          menu = "${inputs.anyrun.packages.${system}.anyrun}/bin/anyrun";
        in
        {
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          exec-once = [
	    "${pkgs.hyprpaper}/bin/hyprpaper"
	    "hyprctl setcursor ${config.chimera.theme.cursor.name} ${builtins.toString config.chimera.theme.cursor.size}"
	  ];

          monitor = config.chimera.hyprland.monitors ++ [ ",preferred,auto,1" ];

          general = {
            border_size = 1;
            "col.active_border" = "rgba(${config.chimera.theme.colors.Surface0.hex}FF)";
            "col.inactive_border" = "rgba(${config.chimera.theme.colors.Surface0.hex}FF)";
          };

          decoration = {
            rounding = 7;
            drop_shadow = false;
          };

          input = {
            kb_layout = config.chimera.input.keyboard.layout;
            kb_variant =
              lib.mkIf (config.chimera.input.keyboard.variant != null)
                config.chimera.input.keyboard.variant;
            natural_scroll = config.chimera.input.mouse.scrolling.natural;

            numlock_by_default = true;

            touchpad = {
              natural_scroll = config.chimera.input.touchpad.scrolling.natural;
            };
          };

          xwayland = {
            force_zero_scaling = true;
          };

          dwindle = {
            pseudotile = true;
            smart_split = true;
          };

          master = {
            allow_small_split = true;
            new_is_master = true;
          };

          windowrulev2 = [ "opacity 1.0 0.85,title:(.*)" ];

          bind =
            [
              "${mod}, Q, killactive"
              "${mod}, SPACE, togglefloating"
              "${mod}, RETURN, exec, ${terminal}"
              "${mod}, down, movefocus, d"
              "${mod}, up, movefocus, u"
              "${mod}, right, movefocus, r"
              "${mod}, left, movefocus, l"
              "${mod}, L, exec, ${lock}"
              "${mod}, D, exec, ${menu}"
            ]
            ++ (builtins.concatLists (
              builtins.genList
                (
                  x:
                  let
                    ws =
                      let
                        c = (x + 1) / 10;
                      in
                      builtins.toString (x + 1 - (c * 10));
                  in
                  [
                    "${mod}, ${ws}, workspace, ${toString (x + 1)}"
                    "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                  ]
                )
                10
            ));

          bindm = [
            "${mod}, mouse:272, movewindow"
            "${mod}, mouse:273, resizewindow"
          ];
        };
    };
  };
}
