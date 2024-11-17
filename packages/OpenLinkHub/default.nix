{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, systemd
}:
let
  version = "0.3.2";
  OpenLinkHub = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    rev = version;
    hash = "sha256-ecsteDXnQl2QJ0sKNGSJqKZJF5JbM9Y3ht/H9Uu1CcA=";
  };
in
buildGoModule {
  pname = "OpenLinkHub";
  inherit version;

  src = OpenLinkHub;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd.dev ];

  postInstall = ''
    mkdir -p $out/var/lib/OpenLinkHub
    cp -r ${OpenLinkHub}/{static,web} $out/var/lib/OpenLinkHub
    cp ${OpenLinkHub}/config.json $out/var/lib/OpenLinkHub
    cp ${OpenLinkHub}/database/rgb.json $out/var/lib/OpenLinkHub
    mkdir -p $out/var/lib/OpenLinkHub/database/keyboard
    cp -r ${OpenLinkHub}/database/keyboard $out/var/lib/OpenLinkHub/database/keyboard
  '';

  vendorHash = "sha256-57ms+wmwXIKBupsYkwuNqeWVwx8nTnu9NX3/VZ0in68=";
}
