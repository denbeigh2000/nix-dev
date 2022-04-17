import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "rust-overlay-2022-04-17";
  url = "https://github.com/oxalica/rust-overlay/archive/26b570500cdd7a359526524e9abad341891122a6.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0rr9kcl6pns5yspjc59hg5ksbddyy8439395n5mnqh6dvsacnvbv";
})
