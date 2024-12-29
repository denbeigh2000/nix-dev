{ pkgs }:

let
  inherit (pkgs.stdenv) system;
  inherit (pkgs) python313 python3;

  packages = ps: with ps; [
    pip
    virtualenv

    pynvim

    python-lsp-server
    pylsp-mypy
    pyls-isort
    python-lsp-black
  ];

in
{
  inherit packages;
  python313 = python313.withPackages packages;
  python312 = python3.withPackages packages;
}
