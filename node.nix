{ pkgs }:

let
  packages = with pkgs.nodePackages; [
    typescript-language-server
  ];

  allNode18 = [ pkgs.nodejs-18_x ] ++ packages;
  allNode16 = [ pkgs.nodejs-16_x ] ++ packages;

in
  {
    inherit (pkgs) nodejs-16_x nodejs-18_x yarn;
    inherit allNode16 allNode18;
  }
