{ ... }: {
  config.xdg.configFile."hypr/hyprpaper.conf".source = builtins.toFile "hyprpaper.conf" ''
    preload = ${./wallpaper.png}

    wallpaper=,${./wallpaper.png}

    splash = true
  '';
}
