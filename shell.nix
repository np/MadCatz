with import <nixpkgs> {};

let py = pkgs.python3Packages; in

py.buildPythonPackage {
  name = "impurePythonEnv";
  buildInputs = [
     ncurses
     zsh
     libusb1
     py.pip
     py.pyqt5
     py.virtualenv

# for python-hidapi
#    automake
#    autoconf
#    libtool
  ];
  src = null;
  # When used as `nix-shell --pure`
  shellHook = ''
  LD_LIBRARY_PATH=
  for i in $nativeBuildInputs; do
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$i/lib
  done
  export LD_LIBRARY_PATH
  export TERM=linux
  unset http_proxy
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  if [ -d venv ]; then
    . ./venv/bin/activate
  else
    virtualenv venv
    . ./venv/bin/activate
    pip install libusb1
  fi
  '';
  # used when building environments
  extraCmds = ''
  unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  '';
}
