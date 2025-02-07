{ pkgs ? import <nixpkgs> { }, ... }:
with pkgs.python3Packages;

let
  textual = buildPythonApplication rec {
    pname = "textual_0_86_2";
    version = "0.86.2";
    pyproject = true;
    build-system = [ poetry-core ];
    dependencies = [
      markdown-it-py
      rich
      typing-extensions
      platformdirs
    ];
    optional-dependencies = {
      syntax = [ pkgs.tree-sitter ]
        ++ pkgs.lib.optionals (!tree-sitter-languages.meta.broken) [ tree-sitter-languages ];
    };
    src = fetchPypi {
      inherit version;
      pname = "textual";
      sha256 = "Qwc/nrUtDzilry8SS6aLN4+R0mDfSxyS84Sjtcu7y3A=";
    };
  };
  textual-autocomplete =
    buildPythonApplication {
      pname = "textual-autocomplete";
      version = "3.0.0a13";
      build-system = [ poetry-core ];
      dependencies = [
        poetry-core
        hatchling
        textual
        typing-extensions
      ];
      pyproject = true;
      # 404 with fetchPypi
      src = builtins.fetchTarball {
        # inherit pname version;
        url = "https://files.pythonhosted.org/packages/bd/d3/7837e2ee1807c72e2a8a185c6e5e729dbe68161d8476055d989f3a2db348/textual_autocomplete-3.0.0a13.tar.gz";
        sha256 = "0fmmplj85z0z7af76r06c86zp29d921hz9373gc6kmwmqxbi2lfh";
      };
  };
in

buildPythonApplication rec {
  pname = "posting";
  version = "2.3.0";
  src = pkgs.fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    tag = version;
    sha256 = "lL85gJxFw8/e8Js+UCE9VxBMcmWRUkHh8Cq5wTC93KA=";
  };
  pyproject = true;
  nativeBuildInputs = [ hatchling ];
  dependencies = [
    click
    click-default-group
    xdg-base-dirs
    pyperclip
    httpx
    httpx.optional-dependencies.brotli
    pydantic
    pydantic-settings
    pyyaml
    python-dotenv
    textual
    textual.optional-dependencies.syntax
    textual-autocomplete
    watchfiles
  ];
}
