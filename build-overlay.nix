{ pkgs, denbeigh-neovim }:
  let
    neovim = import denbeigh-neovim { inherit pkgs; };

    python = import ./python.nix { inherit pkgs; };
    rust = import ./rust.nix { inherit pkgs; };
    goPkg = import ./go.nix { inherit pkgs; };
    node = import ./node.nix { inherit pkgs; };
  in
  {
    devPackages = {
      rust = {
        inherit (rust) all rust rustMinimal rust-analyzer;
      };

      python = {
        inherit (python) python39 python310 packages;
      };

      go = {
        inherit (goPkg) all go gopls;
      };

      node = {
        inherit (node) node16 node18 yarn;
      };
    };
  }
