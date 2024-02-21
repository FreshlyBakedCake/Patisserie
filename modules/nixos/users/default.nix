{ pkgs, ... }:
{
  users.users.minion = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIteIdlZv52nUDxW2SUsoJ2NZi/w9j1NZwuHanQ/o/DuAAAAHnNzaDpjb2xsYWJvcmFfeXViaWtleV9yZXNpZGVudA== collabora_yubikey_resident"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJRzQbQjXFpHKtt8lpNKmoNx57+EJ/z3wnKOn3/LjM6cAAAAFXNzaDppeXViaWtleV9yZXNpZGVudA== iyubikey_resident"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOhzJ0p9bFRSURUjV05rrt5jCbxPXke7juNbEC9ZJXS/AAAAGXNzaDp0aW55X3l1YmlrZXlfcmVzaWRlbnQ= tiny_yubikey_resident"
    ];
    initialPassword = "nixos";
  };

  users.users.coded = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZGErwcw5YUlJS9tAfIYOSqkiuDRZZRTJjMlrDaAiNwTjqUML/Lrcau/1KA6a0+sXCM8DhQ1e0qhh2Qxmh/kxZWO6XMVK2EB7ELPNojqFI16T8Bbhq2t7yVAqbPUhXLQ4xKGvWMCPWOCo/dY72P9yu7kkMV0kTW3nq25+8nvqIvvuQOlOUx1uyR7qEfO706O86wjVTIuwfZKyzMDIC909vyg0xS+SfFlD7MkBuGzevQnOAV3U6tyafg6XW4PaJuDLyGXwpKz6asY08F7gRL/7/GhlMB09nfFfT4sZggmqPdGAtxwsFuwHPjNSlktHz5nlHtpS0LjefR9mWiGIhw5Hw1z33lxP0rfmiEU9J7kFcXv9B8QAWFwWfNEZfeqB7h7DJruo+QRStGeDz4SwRG3GR+DB4iNJLt7n0ALkVFJpOpskeo8TV4+Fwok+hYs2GsvdEmh9Cj7dC/9CyRhJeam9iLIi/iVGZhXEE3tIiqEktZPjiK7JwQyr97zhGJ7Rj4oE= samue@SamuelDesktop"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIH+TJRuMpDPgh6Wp2h+E+O/WoyEAVyWo6SN8oxm2JZNVAAAABHNzaDo= samue@SamuelDesktop"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILrwKN4dJQ0BiLmjsA/66QHhu06+JyokWtHkLcjhWU79AAAABHNzaDo= coded-sk-resident-1"
    ];
    initialPassword = "nixos";
  };

  security.pam.services.waylock = { };
}
