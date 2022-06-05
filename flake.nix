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
      # url = "git+ssh://git@github.com/denbeigh2000/neovim-nix";
      url = "path:/home/denbeigh/dev/mine/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, denbeigh-neovim }:
    let
      makeOverlay = import ./build-overlay.nix;
      overlay = final: prev: (
        let
          pkgs = import nixpkgs {
            system = prev.stdenv.system;
            overlays = [ (import rust-overlay) ];
          };
        in
        makeOverlay { inherit pkgs denbeigh-neovim; }
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
      in
      {
        defaultPackage = pkgs.symlinkJoin {
          name = "denbeigh-devtools";
          version = "0.1.0";
          paths = [ pkgs.neovim python.python310 ] ++ rust.all ++ go.all ++ node.allNode18;
        };

        packages = {
          default = self.defaultPackage."${system}";

          inherit (pkgs) neovim;
          inherit (rust) rust rustMinimal rust-analyzer;
          inherit (python) python39 python310;
          inherit (go) go gopls;
          inherit (node) nodejs-16_x nodejs-18_x yarn;
        };
      }
    );
}
