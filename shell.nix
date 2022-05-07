let
  tools = (import ./default.nix { });

in
with tools;

pkgs.mkShell {
  packages = fullInteractive ++ [ cli ];
}
