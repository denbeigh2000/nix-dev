{ pkgs, rnix-lsp }:
  let
    python = import ./python.nix { inherit pkgs; };
    rust = import ./rust.nix { inherit pkgs; };
    goPkg = import ./go.nix { inherit pkgs; };
    node = import ./node.nix { inherit pkgs; };
    nix = import ./nix.nix { inherit pkgs rnix-lsp; };
  in
  {
    inherit (pkgs) neovim;

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
        inherit (node) nodejs-16_x nodejs-18_x allNode16 allNode18 yarn typescript-language-server;
      };

      inherit nix;
    };
  }
