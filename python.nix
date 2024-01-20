{ pkgs }:

let
  inherit (pkgs.stdenv) system;
  inherit (pkgs) python310 python3;

  packages = ps: with ps; [
    pynvim
    python-lsp-server
    pylsp-mypy
    pyls-isort
    python-lsp-black
  ];

in
{
  inherit packages;
  python310 = python310.withPackages packages;
  python311 = python3.withPackages packages;
}
