{ pkgs, config, inputs, system, ... }: let
  lock = "${pkgs.waylock}/bin/waylock";
in {

  # TODO: Eww, SwayNC, hyprland-per-window-layout, waylock, hy3, anyrun, hypr-empty

  home.packages = [ pkgs.hyprpicker ];

  minion.touchpadGestures.enable = true;

  services.fusuma.settings.swipe = let 
    hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
    jq = "${pkgs.jq}/bin/jq";
    awk = "${pkgs.gawk}/bin/awk";
  in {
    "3".up.command = "${hyprctl} dispatch fullscreen 0";
    "3".down.command = "${hyprctl} dispatch fullscreen 0";
    "4".down.command = lock;
    "3".left.command = "${hyprctl} dispatch workspace $(${hyprctl} activeworkspace -j | ${jq} .id | ${awk} '{print $1+1}')";
    "3".right.command = "${hyprctl} dispatch workspace $(${hyprctl} activeworkspace -j | ${jq} .id | ${awk} '{print $1-1}')";
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd.enable = true;

    settings = let
      mod = "SUPER";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${inputs.anyrun.packages.${system}.anyrun}/bin/anyrun";
    in {
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      exec-once = "${pkgs.hyprpaper}/bin/hyprpaper";

      monitor = [
        "eDP-1,preferred,0x0,1"
        "desc:Dell Inc. DELL P2715Q V7WP95AV914L,preferred,2256x-1956,1,transform,1"
        "desc:AOC 2460G5 0x00023C3F,preferred,336x-1080,1"
        ",preferred,auto,1" # https://wiki.hyprland.org/Configuring/Monitors/
      ];

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

      bind = [
        "${mod}, Q, killactive"
        "${mod}, SPACE, togglefloating"
        "${mod}, RETURN, exec, ${terminal}"
        "${mod}, down, movefocus, d"
        "${mod}, up, movefocus, u"
        "${mod}, right, movefocus, r"
        "${mod}, left, movefocus, l"
        "${mod}, L, exec, ${lock}"
        "${mod}, D, exec, ${menu}"
      ] ++ (
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "${mod}, ${ws}, workspace, ${toString (x + 1)}"
              "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };
}