{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}:
{

  options.chimera.niri = {
    enable = lib.mkEnableOption "Use Niri as your window manager";
    xwayland.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable xwayland-satellite to run X apps in niri";
    };
    monitors = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable this monitor";
            };
            mode = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.submodule {
                  options = {
                    width = lib.mkOption { type = lib.types.int; };
                    height = lib.mkOption { type = lib.types.int; };
                    refresh = lib.mkOption {
                      type = lib.types.nullOr lib.types.float;
                      default = null;
                    };
                  };
                }
              );
              default = null;
            };
            position = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.submodule {
                  options = {
                    x = lib.mkOption { type = lib.types.int; };
                    y = lib.mkOption { type = lib.types.int; };
                  };
                }
              );
              default = null;
            };
            scale = lib.mkOption {
              type = lib.types.float;
              default = 1.0;
            };
            transform = {
              flipped = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              rotation = lib.mkOption {
                type = lib.types.enum [
                  0
                  90
                  180
                  270
                ];
                default = 0;
              };
            };
            variable-refresh-rate = lib.mkEnableOption "Enable Variable Refresh Rate (AMD FreeSync / Nvidia G-Sync)";
          };
        }
      );
      description = "Atribute set of monitors";
      default = { };
    };
    startupCommands = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          command = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Command to run";
          };
        };
      });
      description = "List of commands to run at startup";
      default = [ ];
    };
  };

  config = lib.mkIf config.chimera.niri.enable {
    chimera.wayland.enable = true;

    programs.bash.profileExtra = lib.mkIf config.chimera.shell.bash.enable (
      lib.mkBefore ''
        if [ -z $WAYLAND_DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${pkgs.systemd}/bin/systemd-cat -t niri ${pkgs.dbus}/bin/dbus-run-session ${config.programs.niri.package}/bin/niri --session
        fi
      ''
    );

    programs.zsh.profileExtra = lib.mkIf config.chimera.shell.zsh.enable (
      lib.mkBefore ''
        if [ -z $WAYLAND_DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${pkgs.systemd}/bin/systemd-cat -t niri ${pkgs.dbus}/bin/dbus-run-session ${config.programs.niri.package}/bin/niri --session
        fi
      ''
    );

    programs.niri =
      let
        mod = "Super";
        mod1 = "Alt";
        terminal = "${pkgs.kitty}/bin/kitty";
        menu = (
          if config.chimera.runner.anyrun.enable then
            "${inputs.anyrun.packages.${system}.anyrun}/bin/anyrun"
          else
            ""
        );

        lock = ''${pkgs.swaylock}/bin/swaylock -i ${config.chimera.theme.wallpaper} -s fill'';
      in
      {
        enable = true;
        package = pkgs.niri-stable;
        settings = {
          environment = {
            NIXOS_OZONE_WL = "1";
            DISPLAY = lib.mkIf config.chimera.niri.xwayland.enable ":0";
          };

          input.keyboard = {
            track-layout = "window";
            repeat-delay = 200;
            repeat-rate = 25;
            xkb = {
              layout = config.chimera.input.keyboard.layout;
              variant = config.chimera.input.keyboard.variant;
            };
          };

        input.mouse.natural-scroll = config.chimera.input.mouse.scrolling.natural;
        input.touchpad.natural-scroll = config.chimera.input.touchpad.scrolling.natural;

        input.warp-mouse-to-focus = true;
        input.focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };

        input.power-key-handling.enable = false;

        binds = let
          inherit (config.lib.niri) actions;

          generateWorkspaceBindings = workspaceNumber: {
            "${mod}+${builtins.toString (lib.mod workspaceNumber 10)}".action = actions.focus-workspace workspaceNumber;
            "${mod}+Shift+${builtins.toString (lib.mod workspaceNumber 10)}".action = actions.move-column-to-workspace workspaceNumber;
          };
          joinAttrsetList = listOfAttrsets: lib.fold (a: b: a // b) {} listOfAttrsets;
        in { # General Keybinds
          "${mod}+Q".action = actions.close-window;
          "${mod}+Return".action = actions.spawn "${terminal}";
          "${mod}+L".action = actions.spawn ["sh" "-c" "${config.programs.niri.package}/bin/niri msg action do-screen-transition && ${lock}"];
          "${mod}+P".action = actions.power-off-monitors;

          "${mod}+R".action = actions.screenshot;
          "${mod}+Ctrl+R".action = actions.screenshot-screen;
          "${mod}+Shift+R".action = actions.screenshot-window;
          "Print".action = actions.screenshot;
          "Ctrl+Print".action = actions.screenshot-screen;
          "Shift+Print".action = actions.screenshot-window;

          "${mod}+Space".action = actions."switch-layout" "next";
          "${mod}+Shift+Space".action = actions."switch-layout" "prev";

          "${mod}+D" = lib.mkIf config.chimera.runner.enable { action = actions.spawn "${menu}"; };
          "Alt+Space" = lib.mkIf (
              config.chimera.runner.enable
              && config.chimera.input.keybinds.alternativeSearch.enable
            ) { action = actions.spawn "${menu}"; };
          "${mod}+Shift+Slash".action = actions.show-hotkey-overlay;
        } // ( # Workspace Keybinds
          lib.pipe (lib.range 1 10) [
            (map generateWorkspaceBindings)
            joinAttrsetList
          ]
        ) // ( # Window Manipulation Bindings
        {
          "${mod}+BracketLeft".action = actions."consume-or-expel-window-left";
          "${mod}+BracketRight".action = actions."consume-or-expel-window-right";
          "${mod}+Shift+BracketLeft".action = actions."consume-window-into-column";
          "${mod}+Shift+BracketRight".action = actions."expel-window-from-column";
          "${mod}+Slash".action = actions."switch-preset-column-width";
          "${mod}+${mod1}+F".action = actions."fullscreen-window";

          # Focus
          "${mod}+Up".action = actions."focus-window-or-workspace-up";
          "${mod}+Down".action = actions."focus-window-or-workspace-down";

          # Non Jump Movement
          "${mod}+Shift+Up".action = actions."move-window-up-or-to-workspace-up";
          "${mod}+Shift+Down".action = actions."move-window-down-or-to-workspace-down";
          "${mod}+Shift+Left".action = actions."consume-or-expel-window-left";
          "${mod}+Shift+Right".action = actions."consume-or-expel-window-right";

          # To Monitor
          "${mod}+Shift+Ctrl+Up".action = actions."move-window-to-monitor-up";
          "${mod}+Shift+Ctrl+Down".action = actions."move-window-to-monitor-down";
          "${mod}+Shift+Ctrl+Left".action = actions."move-window-to-monitor-left";
          "${mod}+Shift+Ctrl+Right".action = actions."move-window-to-monitor-right";

          # To Workspace
          "${mod}+Ctrl+Up".action = actions."move-window-to-workspace-up";
          "${mod}+Ctrl+Down".action = actions."move-window-to-workspace-down";

          # Sizing
          "${mod}+Equal".action = actions."set-window-height" "+5%";
          "${mod}+Minus".action = actions."set-window-height" "-5%";
        }) // ( # Column Manipulation Bindings
        {
          # Focus
          "${mod}+Left".action = actions."focus-column-left";
          "${mod}+Right".action = actions."focus-column-right";
          "${mod}+${mod1}+C".action = actions."center-column";
          "${mod}+F".action = actions."maximize-column";

          # Non Monitor Movement
          "${mod}+${mod1}+Shift+Up".action = actions."move-column-to-workspace-up";
          "${mod}+${mod1}+Shift+Down".action = actions."move-column-to-workspace-down";
          "${mod}+${mod1}+Shift+Left".action = actions."move-column-left";
          "${mod}+${mod1}+Shift+Right".action = actions."move-column-right";

          # To Monitor
          "${mod}+${mod1}+Shift+Ctrl+Up".action = actions."move-column-to-monitor-up";
          "${mod}+${mod1}+Shift+Ctrl+Down".action = actions."move-column-to-monitor-down";
          "${mod}+${mod1}+Shift+Ctrl+Left".action = actions."move-column-to-monitor-left";
          "${mod}+${mod1}+Shift+Ctrl+Right".action = actions."move-column-to-monitor-right";

          # Sizing
          "${mod}+${mod1}+Equal".action = actions."set-column-width" "+5%";
          "${mod}+${mod1}+Minus".action = actions."set-column-width" "-5%";
        }) // ( # Workspace Manipulation Bindings
        {
          # Focus
          "${mod}+Page_Up".action = actions."focus-workspace-up";
          "${mod}+Page_Down".action = actions."focus-workspace-down";

          # Within Itself
          "${mod}+Shift+Page_Up".action = actions."move-workspace-up";
          "${mod}+Shift+Page_Down".action = actions."move-workspace-down";

          # To Monitor
          "${mod}+Shift+Ctrl+Page_Up".action = actions."move-workspace-to-monitor-up";
          "${mod}+Shift+Ctrl+Page_Down".action = actions."move-workspace-to-monitor-down";
          "${mod}+Shift+Ctrl+Home".action = actions."move-workspace-to-monitor-left";
          "${mod}+Shift+Ctrl+End".action = actions."move-workspace-to-monitor-right";
        }) // { # Audio
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = actions.spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = actions.spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action = actions.spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action = actions.spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          };
        };

        outputs = config.chimera.niri.monitors;

        cursor = {
          size = config.chimera.theme.cursor.size;
          theme = config.chimera.theme.cursor.name;
        };

        layout = {
          gaps = 16;

          center-focused-column = "on-overflow";

          preset-column-widths = [
            { proportion = 1. / 4.; }
            { proportion = 1. / 3.; }
            { proportion = 1. / 2.; }
            { proportion = 2. / 3.; }
            { proportion = 9. / 10.; }
          ]; # TODO: clicks to PR a docs update for niri-flake
        };

        prefer-no-csd = true; # No "client-side-decorations" (i.e. client-side window open/close buttons)
        hotkey-overlay.skip-at-startup = true;
        screenshot-path = null;

        spawn-at-startup = [
          {
            command = [ "${pkgs.waybar}/bin/waybar" ];
          }
          {
            command = [ "${pkgs.swaybg}/bin/swaybg" "-i" "${config.chimera.theme.wallpaper}" "-m" "fill" ];
          }
          {
            command = [ "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite" ]; # todo: use xwayland-satellite-nixpkgs in the future...
          }
        ] ++ config.chimera.niri.startupCommands;
      };
    };
  };
}
