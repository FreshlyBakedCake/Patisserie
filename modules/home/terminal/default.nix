{
  lib,
  ...
}:
{
  options.chimera.terminal.default = lib.mkOption {
    type = lib.types.str;
    description = "Your default terminal, used in window manager configuration, etc.";
  };
}
