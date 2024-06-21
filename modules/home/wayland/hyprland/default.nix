{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}:
{
  options.chimera = {
    hyprland = {
      enable = lib.mkEnableOption "Use hyprland as your window manager";
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of default monitors to set";
        default = [ ];
      };
      window = {
        rounding = lib.mkOption {
          type = lib.types.int;
          description = "How round the windows should be";
          default = 7;
        };
        blur = lib.mkOption {
          type = lib.types.int;
          description = "How blurred the wallpaper under innactive windows should be";
          default = 8;
        };
      };
      startupApplications = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of commands to run on hyprland start";
        default = [ ];
      };
      keybinds = {
        volumeStep = lib.mkOption {
          type = lib.types.int;
          description = "Amount to increase volume by when media keys are pressed in %";
          example = "5";
          default = 5;
        };
        extraBinds = let
          binds = lib.types.submodule {
            options = {
              meta = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Additional modifier keys space seperated";
                default = null;
              };
              key = lib.mkOption {
                type = lib.types.str;
                description = "Final key";
              };
              function = lib.mkOption {
                type = lib.types.str;
                description = "Hyprland bind function";
              };
            };
          };
        in lib.mkOption {
          type = lib.types.listOf binds;
          description = "Extra keybinds to add";
          default = [ ];
        };
      };
    };
  };
  config = lib.mkIf config.chimera.hyprland.enable (let
    lock = "${pkgs.waylock}/bin/waylock";
  in {
    chimera.wayland.enable = true;

    programs.bash.profileExtra = lib.mkIf config.chimera.shell.bash.enable (lib.mkBefore ''
      if [ -z $WAYLAND_DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec ${pkgs.systemd}/bin/systemd-cat -t hyprland ${pkgs.dbus}/bin/dbus-run-session ${config.wayland.windowManager.hyprland.package}/bin/Hyprland
      fi
    '');

    programs.zsh.profileExtra = lib.mkIf config.chimera.shell.zsh.enable (lib.mkBefore ''
      if [ -z $WAYLAND_DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec ${pkgs.systemd}/bin/systemd-cat -t hyprland ${pkgs.dbus}/bin/dbus-run-session ${config.wayland.windowManager.hyprland.package}/bin/Hyprland
      fi
    '');

    home.packages = [ pkgs.hyprpicker ];

    services.fusuma.settings.swipe = lib.mkIf config.chimera.input.touchpad.enable (
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
          menu = (if config.chimera.runner.anyrun.enable then "${inputs.anyrun.packages.${system}.anyrun}/bin/anyrun" else "");
          screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        in
        {
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          exec-once = [
            "${pkgs.hyprpaper}/bin/hyprpaper"
            "hyprctl setcursor ${config.chimera.theme.cursor.name} ${builtins.toString config.chimera.theme.cursor.size}"
            "${pkgs.waybar}/bin/waybar"
          ] ++ config.chimera.hyprland.startupApplications;

          monitor = config.chimera.hyprland.monitors ++ [ ",preferred,auto,1" ];

          general = {
            border_size = 1;
            "col.active_border" = "rgba(${config.chimera.theme.colors.Surface0.hex}FF)";
            "col.inactive_border" = "rgba(${config.chimera.theme.colors.Surface0.hex}FF)";
          };

          decoration = {
            rounding = config.chimera.hyprland.window.rounding;
            drop_shadow = false;
            blur.size = config.chimera.hyprland.window.blur;
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
              "${mod}, R, exec, ${screenshot}"
              ", Print, exec, ${screenshot}"
            ]
            ++ (if config.chimera.runner.enable then [ "${mod}, D, exec, ${menu}" ] else [])
            ++ (if lib.and config.chimera.input.keybinds.alternativeSearch.enable config.chimera.runner.enable then [ "ALT, SPACE, exec, ${menu}" ] else [])
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
            ))
            ++ (builtins.map (item: (if item.meta != null then "SUPER_${item.meta}" else "SUPER") + ", ${item.key}, ${item.function}") config.chimera.hyprland.keybinds.extraBinds)
            ++ [
              # Volume controls
              ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i ${toString config.chimera.hyprland.keybinds.volumeStep}"
              ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d ${toString config.chimera.hyprland.keybinds.volumeStep}"
              ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
              # Pause and play
              ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
              # Next and previous
              ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
              ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
            ];

          bindm = [
            "${mod}, mouse:272, movewindow"
            "${mod}, mouse:273, resizewindow"
          ];

          env = lib.mkIf config.chimera.nvidia.enable [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "WLR_NO_HARDWARE_CURSORS,1"
          ];
        };
    };
  });
}
