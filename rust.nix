{ pkgs }:

let
  inherit (pkgs) rust-analyzer;
  rust = pkgs.rust-bin.stable."1.61.0".default;
  rustMinimal = pkgs.rust-bin.stable."1.61.0".minimal;

  all = [ rust rust-analyzer ];

in
{
  inherit all rust rustMinimal rust-analyzer;
}
