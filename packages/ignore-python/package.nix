{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ignore_python";
  version = "0.3.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    dist = "cp312";
    python = "cp312";
    abi = "cp312";
    platform =
      if python3.pkgs.stdenv.hostPlatform.isLinux then
        "manylinux_2_17_x86_64.manylinux2014_x86_64"
      else if python3.pkgs.stdenv.hostPlatform.isDarwin then
        if python3.pkgs.stdenv.hostPlatform.isAarch64 then
          "macosx_11_0_arm64"
        else
          "macosx_10_12_x86_64"
      else
        throw "Unsupported platform";
    hash =
      if python3.pkgs.stdenv.hostPlatform.isLinux then
        "sha256-e8y4c4XXFIrzxE+/me+ZjmPY8aLCokr0P/qto02kfdg="
      else if python3.pkgs.stdenv.hostPlatform.isDarwin && python3.pkgs.stdenv.hostPlatform.isAarch64 then
        "sha256-DkMP7mG2GRR+xEj8wpzSd1CCAAAAbqw8IrgIB2xDqzY="
      else if python3.pkgs.stdenv.hostPlatform.isDarwin then
        "sha256-sAyqnvRCNI1I/kOI+OFg2y3gDEhyoZvd7NyY937hmlc="
      else
        throw "Unsupported platform";
  };

  pythonImportsCheck = [ "ignore" ];

  meta = with lib; {
    description = "Python bindings for the Rust ignore crate - fast recursive directory iterator respecting gitignore rules";
    homepage = "https://github.com/borsattoz/ignore-python";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
