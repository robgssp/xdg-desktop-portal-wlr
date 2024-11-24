{ lib
, stdenv
, bash
, fetchFromGitHub
, makeWrapper
, meson
, ninja
, pkg-config
, wayland-protocols
, wayland-scanner
, grim
, inih
, libdrm
, mesa
, pipewire
, scdoc
, slurp
, systemd
, wayland
, valgrind
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = "0.7.1";

  src = ./.;

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner makeWrapper valgrind ];
  buildInputs = [ inih libdrm mesa pipewire systemd wayland wayland-protocols ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-wlr --prefix PATH ":" ${lib.makeBinPath [ bash grim slurp ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr";
    description = "xdg-desktop-portal backend for wlroots";
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}