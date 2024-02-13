{ lib, config, ... }: {
  options.chimera.browser.chromium = {
    enable = lib.mkEnableOption "Use chromium browser";
    extensions = {
      bitwarden.enable = lib.mkEnableOption "Turn on Bitwarden extension";
      youtube = {
        sponsorBlock.enable = lib.mkEnableOption "Turn on Sponsor Block";
        returnDislike.enable = lib.mkEnableOption "Turn on Return Youtube Dislike";
        deArrow.enable = lib.mkEnableOption "Turn on De Arrow";
      };
      reactDevTools.enable = lib.mkEnableOption "Turn on React Dev Tools";
      ublockOrigin.enable = lib.mkEnableOption "Turn on uBlock Origin ad blocker";
    };
    extraExtensions = lib.mkOption {
      type = lib.types.listOf (lib.types.either { id = lib.types.str; } { id = lib.types.str; crxPath = lib.types.path; version = lib.types.str; });
      description = "Extra extensions to add to chromium on launch";
      default = [];
    };
  };
  config = lib.mkIf config.chimera.browser.chromium.enable ({
    programs.chromium = {
      enable = true;
      extensions =
        (if config.chimera.browser.chromium.extensions.bitwarden.enable then [{ id = "nngceckbapebfimnlniiiahkandclblb"; }] else []) #Bitwarden
        ++ (if config.chimera.browser.chromium.extensions.youtube.sponsorBlock.enable then [{ id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }] else []) #Sponsor Block
        ++ (if config.chimera.browser.chromium.extensions.youtube.returnDislike.enable then [{ id = "gebbhagfogifgggkldgodflihgfeippi"; }] else []) #Return youtube dislike
        ++ (if config.chimera.browser.chromium.extensions.youtube.deArrow.enable then [{ id = "enamippconapkdmgfgjchkhakpfinmaj"; }] else []) #DeArrow
        ++ (if config.chimera.browser.chromium.extensions.reactDevTools.enable then [{ id = "fmkadmapgofadopljbjfkapdkoienihi"; }] else []) #React Dev Tools
        ++ (if config.chimera.browser.chromium.extensions.ublockOrigin.enable then [{ id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }] else []) #uBlock Origin
        ++ config.chimera.browser.chromium.extraExtensions;
    };
  });
}