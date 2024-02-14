{ lib, config, ... }:
{
  options.chimera.browser.firefox = {
    enable = lib.mkEnableOption "Use firefox browser";
    extensions = {
      bitwarden.enable = lib.mkEnableOption "Turn on Bitwarden extension";
      youtube = {
        sponsorBlock.enable = lib.mkEnableOption "Turn on Sponsor Block";
        returnDislike.enable = lib.mkEnableOption "Turn on Return Youtube Dislike";
        deArrow.enable = lib.mkEnableOption "Turn on De Arrow";
      };
      reactDevTools.enable = lib.mkEnableOption "Turn on React Dev Tools";
      ublockOrigin.enable = lib.mkEnableOption "Turn on uBlock Origin ad blocker";
      adnauseam.enable = lib.mkEnableOption "Turn on AdNauseam ad blocker";
    };
    extraExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Extra extensions to add to firefox";
    };
  };
  config = lib.mkIf config.chimera.browser.firefox.enable ({
    programs.firefox = {
      enable = true;
      profiles.chimera.extensions =
        (
          if config.chimera.browser.firefox.extensions.bitwarden.enable then
            [ config.nur.repos.rycee.firefox-addons.bitwarden ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.youtube.sponsorBlock.enable then
            [ config.nur.repos.rycee.firefox-addons.sponsorblock ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.youtube.returnDislike.enable then
            [ config.nur.repos.rycee.firefox-addons.return-youtube-dislikes ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.youtube.deArrow.enable then
            [ config.nur.repos.rycee.firefox-addons.dearrow ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.reactDevTools.enable then
            [ config.nur.repos.rycee.firefox-addons.react-devtools ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.ublockOrigin.enable then
            [ config.nur.repos.rycee.firefox-addons.ublock-origin ]
          else
            [ ]
        )
        ++ (
          if config.chimera.browser.firefox.extensions.adnauseam.enable then
            [ config.nur.repos.rycee.firefox-addons.adnauseam ]
          else
            [ ]
        )
        ++ config.chimera.browser.firefox.extraExtensions;
    };
  });
}
