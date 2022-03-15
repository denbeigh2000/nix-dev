{ system ? builtins.currentSystem }:

import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2022-03-12";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/fcd48a5a0693f016a5c370460d0c2a8243b882dc.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "06nyvac1azpa9gqdhj9py6ljsvbfgx49ilp8kf6w0w9clxba64vg";
}) { system = system; }
