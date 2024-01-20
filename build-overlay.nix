{ pkgs }:
let
  python = import ./python.nix { inherit pkgs; };
  rust = import ./rust.nix { inherit pkgs; };
  go = import ./go.nix { inherit pkgs; };
  node = import ./node.nix { inherit pkgs; };
in
{
  devPackages = {
    rust = {
      inherit (rust) all rust rustMinimal rust-analyzer;
    };

    python = {
      inherit (python) python310 python311 packages;
    };

    go = {
      inherit (go) all go gopls;
    };

    node = {
      inherit (node) nodejs_20 nodejs_21 allNode20 allNode21 yarn typescript-language-server;
    };
  };
}
