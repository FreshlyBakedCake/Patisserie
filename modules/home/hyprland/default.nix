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
  options.chimera.hyprland = {
    enable = lib.mkEnableOption "Use hyprland as your window manager";

    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of default monitors to set";
      default = [ ];
    };
  };

  /* general = {
       gaps_in = 5;
       gaps_out = 20;

       border_size = 1;
       "col.active_border" = "rgba(71AEF5EE)";
       "col.inactive_border" = "rgba(C4C4C4EE)";

       layout = "dwindle";
     };

     dwindle = {
       pseudotile = true;
       smart_split = true;
     };

     master = {
       allow_small_split = true;
       new_is_master = true;
     };

     decoration = {
       rounding = 7;

       drop_shadow = true;
       shadow_range = 4;
       shadow_render_power = 3;
       "col.shadow" = "rgba(1a1a1aee)";
     };
  */

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

          exec-once = "${pkgs.hyprpaper}/bin/hyprpaper";

          monitor = config.chimera.hyprland.monitors ++ [ ",preferred,auto,1" ];

          decoration = {
            rounding = 7;
          };

          input = {
            kb_layout = "us";
            kb_variant = "dvorak";
            natural_scroll = true;

            touchpad = {
              natural_scroll = true;
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
