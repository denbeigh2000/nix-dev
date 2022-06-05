{
  description = "A sample Rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    dev.url = "github:denbeigh2000/nix-dev"; # Include as an input
    dev.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, dev }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ dev.overlay ]; # Use overlay
      };
    in
    {
      devShell."${system}" = pkgs.mkShell {
        # Create a devShell for `nix develop`
        packages = with pkgs.devPackages; [ neovim ] ++ rust.all ++ nix.all;
      };
    };
}
