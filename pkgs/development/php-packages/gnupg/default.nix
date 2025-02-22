{ buildPecl, lib, gpgme, file, gnupg }:

buildPecl {
  pname = "gnupg";

  version = "1.5.0";
  sha256 = "0r0akrjjf9i460z11llybdr6sg2rlcz38nwfy0yqz443ljdggxfl";

  buildInputs = [ gpgme ];
  checkInputs = [ gnupg ];

  postPhpize = ''
    substituteInPlace configure \
      --replace '/usr/bin/file' '${file}/bin/file' \
      --replace 'SEARCH_PATH="/usr/local /usr /opt"' 'SEARCH_PATH="${gpgme.dev}"'
  '';

  postConfigure = with lib; ''
    substituteInPlace Makefile \
      --replace 'run-tests.php' 'run-tests.php -q --offline'
    substituteInPlace tests/gnupg_res_init_file_name.phpt \
      --replace '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace 'string(12)' 'string(${toString (stringLength "${gnupg}/bin/gpg")})'
    substituteInPlace tests/gnupg_oo_init_file_name.phpt \
      --replace '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace 'string(12)' 'string(${toString (stringLength "${gnupg}/bin/gpg")})'
  '';

  doCheck = true;

  meta = with lib; {
    description = "PHP wrapper for GpgME library that provides access to GnuPG";
    license = licenses.bsd3;
    homepage = "https://pecl.php.net/package/gnupg";
    maintainers = with maintainers; [ taikx4 ] ++ teams.php.members;
  };
}
