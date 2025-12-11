{
  lib,
  python3,
  fetchFromGitHub,
  ignore-python,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _final: _prev: {
      inherit ignore-python;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "cased-kit";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cased";
    repo = "kit";
    rev = "v${version}";
    hash = "sha256-uDwCgkBQVN3YlPqJWiFrkXIvkWLKawyiCJ7RzPL5kKM=";
  };

  build-system = with python.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    tree-sitter
    tree-sitter-language-pack
    pathspec
    ignore-python
    numpy
    fastapi
    uvicorn
    typer
    click
    openai
    tiktoken
    anthropic
    google-genai
    python-hcl2
    mcp
    redis
    requests
    pyyaml
  ];

  optional-dependencies = {
    all = with python.pkgs; [
      sentence-transformers
      chromadb
    ];
  };

  pythonRelaxDeps = [
    "typer"
    "click"
  ];

  pythonImportsCheck = [ "kit" ];

  # Tests require API keys and external services
  doCheck = false;

  meta = with lib; {
    description = "Production-ready toolkit for codebase mapping, symbol extraction, code search, and building LLM-powered developer tools";
    homepage = "https://github.com/cased/kit";
    changelog = "https://github.com/cased/kit/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
    mainProgram = "kit";
  };
}
