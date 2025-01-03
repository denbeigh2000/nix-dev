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

    denbeigh-ci = {
      url = "github:denbeigh2000/ci";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, denbeigh-ci, ... }:
    let
      makeOverlay = import ./build-overlay.nix;
      overlays = [ (import rust-overlay) ];
      overlay = final: prev: (
        let
          pkgs = import nixpkgs {
            system = prev.stdenv.system;
            inherit overlays;
          };
        in
        makeOverlay { inherit pkgs; }
      );
    in
    { overlays.default = overlay; } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit overlays system; };

        python = import ./python.nix { inherit pkgs; };
        rust = import ./rust.nix { inherit pkgs; };
        go = import ./go.nix { inherit pkgs; };
        node = import ./node.nix { inherit pkgs; };
        nix = import ./nix.nix { inherit pkgs; };

        defaultSet = [ python.python312 ] ++ rust.all ++ go.all ++ node.allNode22;
      in
      {
        ci = denbeigh-ci.lib.mkCIConfig { inherit self pkgs; };

        devShells.default = pkgs.mkShell {
          packages = defaultSet;
        };

        packages = {
          default = pkgs.symlinkJoin {
            name = "denbeigh-devtools";
            version = "0.1.0";
            paths = defaultSet;
          };

          inherit (pkgs) neovim;
          inherit (rust) rust rustMinimal rust-analyzer;
          inherit (python) python312 python313;
          inherit (go) go gopls;
          inherit (node) nodejs_20 nodejs_22 yarn;
        };
      }
    );
}
