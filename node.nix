{ pkgs }:

let
  packages = with pkgs.nodePackages; [
    typescript-language-server
  ];

  allNode21 = [ pkgs.nodejs_21 ] ++ packages;
  allNode20 = [ pkgs.nodejs_20 ] ++ packages;

in
{
  inherit (pkgs.nodePackages) typescript-language-server;
  inherit (pkgs) nodejs_20 nodejs_21 yarn;
  inherit allNode20 allNode21;
}
