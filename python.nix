{ pkgs ? import ./pkgs.nix {} }:

# []

# TODO: Python needs to be compiled from source on nixos docker for some
# reason.
[
  pkgs.python310
  # TODO: Why is this not on nixos?
  pkgs.python310Packages.python-lsp-server
  pkgs.python310Packages.pynvim
]
