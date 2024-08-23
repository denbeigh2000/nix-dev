{ pkgs }:

let
  packages = with pkgs.nodePackages; [
    typescript-language-server
  ];

  allNode22 = [ pkgs.nodejs_22 ] ++ packages;
  allNode20 = [ pkgs.nodejs_20 ] ++ packages;

in
{
  inherit (pkgs.nodePackages) typescript-language-server;
  inherit (pkgs) nodejs_20 nodejs_22 yarn;
  inherit allNode20 allNode22;
}
