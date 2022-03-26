
{ system ? builtins.currentSystem }:

import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-unstable-2022-03-24";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/4d60081494259c0785f7e228518fee74e0792c1b.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "15vxvzy9sxsnnxn53w2n44vklv7irzxvqv8xj9dn78z9zwl17jhq";
}) { system = system; }
