{
  description = "A flake containing Denbeigh's assorted dev tooling";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    denbeigh-neovim = {
      url = "github:denbeigh2000/neovim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, denbeigh-neovim, rnix-lsp }:
    let
      makeOverlay = import ./build-overlay.nix;
      overlay = final: prev: (
        let
          pkgs = import nixpkgs {
            system = prev.stdenv.system;
            overlays = [ (import rust-overlay) denbeigh-neovim.overlay ];
          };
        in
        makeOverlay { inherit pkgs rnix-lsp; }
      );
    in
    { inherit overlay; } // flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) denbeigh-neovim.overlay ];
        pkgs = import nixpkgs { inherit overlays system; };

        python = import ./python.nix { inherit pkgs; };
        rust = import ./rust.nix { inherit pkgs; };
        go = import ./go.nix { inherit pkgs; };
        node = import ./node.nix { inherit pkgs; };
        nix = import ./nix.nix { inherit pkgs rnix-lsp; };

        defaultSet = [ pkgs.neovim python.python310 nix.rnix-lsp ] ++ rust.all ++ go.all ++ node.allNode18;
      in
      {
        defaultPackage = pkgs.symlinkJoin {
          name = "denbeigh-devtools";
          version = "0.1.0";
          paths = defaultSet;
        };

        devShell = pkgs.mkShell {
          packages = defaultSet;
        };

        packages = {
          default = self.defaultPackage."${system}";

          inherit (pkgs) neovim;
          inherit (rust) rust rustMinimal rust-analyzer;
          inherit (python) python39 python310;
          inherit (go) go gopls;
          inherit (node) nodejs-16_x nodejs-18_x yarn;
          inherit (nix) rnix-lsp;
        };
      }
    );
}
