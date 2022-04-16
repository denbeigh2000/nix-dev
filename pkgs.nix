{ system ? builtins.currentSystem }:

let
  rust-overlay = (import ./rust_overlay/default.nix);
  pkgs = import (./nixpkgs/default.nix);
in
  pkgs {
    system = system;
    overlays = [rust-overlay];
  }
