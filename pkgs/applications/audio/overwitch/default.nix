{ lib
, stdenv
, fetchFromGitHub
, libtool
, libusb1
, libjack2
, libsamplerate
, libsndfile
, gettext
, json-glib
, gtk3
, wrapGAppsHook
, pkg-config
, autoreconfHook
, withGui ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "overwitch";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = "overwitch";
    rev = finalAttrs.version;
    sha256 = "sha256-PVndXjxcP9nIVP0r1KfeYKzMKTqMCdhi6dCL/B85tYw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook
  ];

  buildInputs = [
    libtool
    libusb1
    libjack2
    libsamplerate
    libsndfile
    gettext
    json-glib
    gtk3
  ];

  configureFlags = [
    (lib.optionalString (!withGui) "CLI_ONLY=yes")
  ];

  postInstall = ''
    # install udev/hwdb rules
    mkdir -p $out/etc/udev/rules.d/
    mkdir -p $out/etc/udev/hwdb.d/
    cp ./udev/*.hwdb $out/etc/udev/hwdb.d/
    cp ./udev/*.rules $out/etc/udev/rules.d/
  '';

  meta = with lib; {
    description = "JACK client for Overbridge devices";
    homepage = "https://github.com/dagargo/overwitch";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dag-h ];
  };
})
