{ pkgs ? import ./pkgs.nix {} }:

[
  pkgs.python310
  pkgs.python310Packages.python-lsp-server
  pkgs.python310Packages.pynvim
]
