
{ system ? builtins.currentSystem }:

import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-unstable-2022-03-14";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/3239fd2b8f728106491154b44625662e10259af2.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0bn0dcd7casv9kwxpa22mxizs8gmrpgi5xba0qr7g6fi7l5lnp1v";
}) { system = system; }
