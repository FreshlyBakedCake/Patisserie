{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, systemd
}:
let
  version = "0.2.1";
  OpenLinkHub = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    rev = version;
    hash = "sha256-2naNOGRPKy8H9I4e6X+uX3muT20M9YX2BGrPmY7RVAo=";
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
  '';

  vendorHash = "sha256-Sv2gGnI3mJvOl866idKC1q+6jh4ysEot0eLLBKPb0T0=";
}
