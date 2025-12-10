{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "linearis";
  version = "unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "czottmann";
    repo = "linearis";
    rev = "330d29b7ae725fb71bacaf692b7489dcc1256434";
    hash = "sha256-IFZIh9PR5dmSG+c8+ZOSa3jYp7XR65Vj82WYMjMNbsM=";
  };

  npmDepsHash = "sha256-PUXLphH82leQLHj5+BIxezKSpRiK/S9WevzK0duwo28=";

  meta = with lib; {
    description = "CLI tool for Linear.app with JSON output, smart ID resolution, and optimized GraphQL queries";
    homepage = "https://github.com/czottmann/linearis";
    changelog = "https://github.com/czottmann/linearis/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with maintainers; [ ];
    mainProgram = "linearis";
    platforms = platforms.all;
  };
}
