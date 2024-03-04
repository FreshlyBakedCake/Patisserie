{ pkgs, ... }:
{
  users.mutableUsers = false;

  users.users.minion = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "dialout"
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIteIdlZv52nUDxW2SUsoJ2NZi/w9j1NZwuHanQ/o/DuAAAAHnNzaDpjb2xsYWJvcmFfeXViaWtleV9yZXNpZGVudA== collabora_yubikey_resident"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJRzQbQjXFpHKtt8lpNKmoNx57+EJ/z3wnKOn3/LjM6cAAAAFXNzaDppeXViaWtleV9yZXNpZGVudA== iyubikey_resident"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOhzJ0p9bFRSURUjV05rrt5jCbxPXke7juNbEC9ZJXS/AAAAGXNzaDp0aW55X3l1YmlrZXlfcmVzaWRlbnQ= tiny_yubikey_resident"
    ];
  };

  users.users.coded = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILrwKN4dJQ0BiLmjsA/66QHhu06+JyokWtHkLcjhWU79AAAABHNzaDo= coded-yk5c-resident"
    ];
  };

  security.pam.services.waylock = { };
}
