{
  inputs,
  lib,
  gtimelog,
  glib-networking,
  gtk3,
  libsoup_2_4,
  glib,
  pango,
  harfbuzz,
  gdk-pixbuf,
  atk,
  libsecret,
  gobject-introspection,
  ...
}:
gtimelog.overrideAttrs (oldAttrs: {
  src = inputs.collabora-gtimelog;
  makeWrapperArgs = [
    "--set GIO_MODULE_DIR ${lib.makeSearchPathOutput "out" "lib/gio/modules" [ glib-networking ]}"
    "--set GI_TYPELIB_PATH ${
      lib.makeSearchPathOutput "out" "lib/girepository-1.0" [
        gtk3
        libsoup_2_4
        glib
        pango
        harfbuzz
        gdk-pixbuf
        atk
        libsecret
      ]
    }"
  ];
  buildInputs = oldAttrs.buildInputs ++ [ glib-networking ];
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ gobject-introspection ];
  preInstall = ''
    cp ${inputs.collabora-icon} src/gtimelog/gtimelog-large.png
  '';
})
