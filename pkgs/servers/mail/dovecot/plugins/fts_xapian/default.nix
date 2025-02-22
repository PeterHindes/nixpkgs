{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, dovecot, libtool, xapian, icu64 }:
stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    sha256 = "1ap4jb43gvy7caa8lg2hg811q0n5c2gqbmcjl4126wz44hb7waa1";
  };

  buildInputs = [ dovecot xapian icu64 ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = ''
    export PANDOC=false
    autoreconf -vi
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ julm symphorien ];
    platforms = platforms.unix;
  };
}
