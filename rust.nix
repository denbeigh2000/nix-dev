{ pkgs, rustVersion ? "latest" }:

let
  inherit (pkgs) rust-analyzer;
  rust = pkgs.rust-bin.stable."${rustVersion}".default;
  rustMinimal = pkgs.rust-bin.stable."${rustVersion}".minimal;

  all = [ rust rust-analyzer ];

in
{
  inherit all rust rustMinimal rust-analyzer;
}
