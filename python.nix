{ pkgs }:

let
  inherit (pkgs.stdenv) system;
  inherit (pkgs) python39 python310;
  packages = packages:
    with packages; ([ pynvim ]) ++ (
      # NOTE: Disabled on aarch64-darwin due to broken pyopenssl dependency
      # https://github.com/NixOS/nixpkgs/pull/172397
      if system != "aarch64-darwin"
      then
        ([
          python-lsp-server
          pylsp-mypy
          pyls-isort
          python-lsp-black
        ]) else [ ]
    );

in
{
  inherit packages;
  python39 = python39.withPackages packages;
  python310 = python310.withPackages packages;
}
