{ pkgs ? import <nixpkgs> {} }:

[
  pkgs.rustc
  pkgs.rustfmt
  pkgs.rust-analyzer
  pkgs.cargo
]
