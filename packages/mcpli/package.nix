{
  lib,
  flake,
  stdenv,
  fetchzip,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "mcpli";
  version = "0.3.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-6WcxxDbz3hbXJx+adZ1ngO2cBZIINJTdk4+/8BzsBsE=";
  };

  nativeBuildInputs = [ nodejs ];

  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/lib/mcpli

        # Copy the main executable
        cp $src/dist/mcpli.js $out/lib/mcpli/mcpli.js
        chmod +x $out/lib/mcpli/mcpli.js

        # Copy the daemon wrapper
        mkdir -p $out/lib/mcpli/daemon
        cp $src/dist/daemon/wrapper.js $out/lib/mcpli/daemon/wrapper.js
        chmod +x $out/lib/mcpli/daemon/wrapper.js

        # Fix shebangs
        substituteInPlace $out/lib/mcpli/mcpli.js \
          --replace-quiet "#!/usr/bin/env node" "#!${nodejs}/bin/node"

        substituteInPlace $out/lib/mcpli/daemon/wrapper.js \
          --replace-quiet "#!/usr/bin/env node" "#!${nodejs}/bin/node"

        # Create wrapper script in bin
        cat > $out/bin/mcpli <<EOF
    #!${stdenv.shell}
    exec ${nodejs}/bin/node $out/lib/mcpli/mcpli.js "\$@"
    EOF
        chmod +x $out/bin/mcpli

        runHook postInstall
  '';

  # mcpli doesn't support --version without requiring MCP server arguments
  doInstallCheck = false;

  meta = with lib; {
    description = "Transform stdio-based MCP servers into first-class CLI tools (macOS only - requires launchd daemon)";
    homepage = "https://github.com/cameroncooke/mcpli";
    changelog = "https://github.com/cameroncooke/mcpli/releases";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with flake.lib.maintainers; [ ypares ];
    mainProgram = "mcpli";
    platforms = platforms.darwin;
    broken = !stdenv.isDarwin;
  };
}
