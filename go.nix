{ pkgs }:

let
  inherit (pkgs) go gopls;
in
{
  inherit go gopls;
  all = [ go gopls ];
}
