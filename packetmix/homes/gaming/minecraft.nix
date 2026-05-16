# SPDX-FileCopyrightText: 2025 FreshlyBakedCake
#
# SPDX-License-Identifier: MIT

{ pkgs, ... }:
{
  home.packages = [ pkgs.prismlauncher ];

  clicks.storage.impermanence.persist.directories = [
    ".local/share/PrismLauncher"
  ];
}
