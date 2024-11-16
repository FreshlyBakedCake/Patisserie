{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}:
let
inherit (inputs) nixpkgs-stable;
in {

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
              options = lib.mkIf (config.chimera.input.keyboard.appleMagic) "apple:alupckeys";
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
            "${mod}+${builtins.toString (lib.mod workspaceNumber 10)}".action.focus-workspace = [workspaceNumber];
            "${mod}+Shift+${builtins.toString (lib.mod workspaceNumber 10)}".action.move-column-to-workspace = [workspaceNumber];
          };
          joinAttrsetList = listOfAttrsets: lib.fold (a: b: a // b) {} listOfAttrsets;
        in { # General Keybinds
          "${mod}+Q".action.close-window = [];
          "${mod}+Shift+Q".action.quit = [];
          "${mod}+Return".action.spawn = "${terminal}";
          "${mod}+L".action.spawn = ["sh" "-c" "${config.programs.niri.package}/bin/niri msg action do-screen-transition && ${lock}"];
          "${mod}+P".action.power-off-monitors = [];

          "${mod}+R".action.screenshot = [];
          "${mod}+Ctrl+R".action.screenshot-screen = [];
          "${mod}+Shift+R".action.screenshot-window = [];
          "Print".action.screenshot = [];
          "Ctrl+Print".action.screenshot-screen = [];
          "Shift+Print".action.screenshot-window = [];

          "${mod}+Alt+R".action.spawn = ["sh" "-c" ''([ -d Videos ] || mkdir Videos) && ${nixpkgs-stable.legacyPackages.${system}.wl-screenrec}/bin/wl-screenrec --geometry "$(${pkgs.slurp}/bin/slurp)" --filename "Videos/$(date +'%Y-%m-%d-%H-%M-%S').mp4"''];
          "${mod}+Alt+Shift+R".action.spawn = ["sh" "-c" "pkill wl-screenrec && cat \"$(${pkgs.coreutils}/bin/ls -t Videos/*.mp4 | ${pkgs.coreutils}/bin/head -n 1)\" | ${pkgs.wl-clipboard}/bin/wl-copy"];

          "${mod}+Space".action.switch-layout = ["next"];
          "${mod}+Shift+Space".action.switch-layout = ["prev"];

          "${mod}+D" = lib.mkIf config.chimera.runner.enable { action.spawn = "${menu}"; };
          "Alt+Space" = lib.mkIf (
              config.chimera.runner.enable
              && config.chimera.input.keybinds.alternativeSearch.enable
            ) { action.spawn = "${menu}"; };
          "${mod}+Shift+Slash".action.show-hotkey-overlay = [];
        } // ( # Workspace Keybinds
          lib.pipe (lib.range 1 10) [
            (map generateWorkspaceBindings)
            joinAttrsetList
          ]
        ) // ( # Window Manipulation Bindings
        {
          "${mod}+BracketLeft".action.consume-or-expel-window-left = [];
          "${mod}+BracketRight".action.consume-or-expel-window-right = [];
          "${mod}+Shift+BracketLeft".action.consume-window-into-column = [];
          "${mod}+Shift+BracketRight".action.expel-window-from-column = [];
          "${mod}+Slash".action.switch-preset-column-width = [];
          "${mod}+${mod1}+F".action.fullscreen-window = [];

          # Focus
          "${mod}+Up".action.focus-window-or-workspace-up = [];
          "${mod}+Down".action.focus-window-or-workspace-down = [];

          # Non Jump Movement
          "${mod}+Shift+Up".action.move-window-up-or-to-workspace-up = [];
          "${mod}+Shift+Down".action.move-window-down-or-to-workspace-down = [];
          "${mod}+Shift+Left".action.consume-or-expel-window-left = [];
          "${mod}+Shift+Right".action.consume-or-expel-window-right = [];

          # To Monitor
          "${mod}+Shift+Ctrl+Up".action.move-window-to-monitor-up = [];
          "${mod}+Shift+Ctrl+Down".action.move-window-to-monitor-down = [];
          "${mod}+Shift+Ctrl+Left".action.move-window-to-monitor-left = [];
          "${mod}+Shift+Ctrl+Right".action.move-window-to-monitor-right = [];

          # To Workspace
          "${mod}+Ctrl+Up".action.move-window-to-workspace-up = [];
          "${mod}+Ctrl+Down".action.move-window-to-workspace-down = [];

          # Sizing
          "${mod}+Equal".action.set-window-height = ["+5%"];
          "${mod}+Minus".action.set-window-height = ["-5%"];
        }) // ( # Column Manipulation Bindings
        {
          # Focus
          "${mod}+Left".action.focus-column-left = [];
          "${mod}+Right".action.focus-column-right = [];
          "${mod}+${mod1}+C".action.center-column = [];
          "${mod}+F".action.maximize-column = [];

          # Non Monitor Movement
          "${mod}+${mod1}+Shift+Up".action.move-column-to-workspace-up = [];
          "${mod}+${mod1}+Shift+Down".action.move-column-to-workspace-down = [];
          "${mod}+${mod1}+Shift+Left".action.move-column-left = [];
          "${mod}+${mod1}+Shift+Right".action.move-column-right = [];

          # To Monitor
          "${mod}+${mod1}+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
          "${mod}+${mod1}+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
          "${mod}+${mod1}+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
          "${mod}+${mod1}+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];

          # Sizing
          "${mod}+${mod1}+Equal".action.set-column-width = ["+5%"];
          "${mod}+${mod1}+Minus".action.set-column-width = ["-5%"];
        }) // ( # Workspace Manipulation Bindings
        {
          # Focus
          "${mod}+Page_Up".action.focus-workspace-up = [];
          "${mod}+Page_Down".action.focus-workspace-down = [];

          # Within Itself
          "${mod}+Shift+Page_Up".action.move-workspace-up = [];
          "${mod}+Shift+Page_Down".action.move-workspace-down = [];

          # To Monitor
          "${mod}+Shift+Ctrl+Page_Up".action.move-workspace-to-monitor-up = [];
          "${mod}+Shift+Ctrl+Page_Down".action.move-workspace-to-monitor-down = [];
          "${mod}+Shift+Ctrl+Home".action.move-workspace-to-monitor-left = [];
          "${mod}+Shift+Ctrl+End".action.move-workspace-to-monitor-right = [];
        }) // { # Audio
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
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

        spawn-at-startup = (if config.chimera.waybar.enable then [{
            command = [ "${pkgs.waybar}/bin/waybar" ];
          }] else []) ++ [
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
