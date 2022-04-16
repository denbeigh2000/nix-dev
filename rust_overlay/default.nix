import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "rust-overlay-2022-04-16";
  url = "https://github.com/oxalica/rust-overlay/archive/d154de7dae2da8b52084ddbfe95ce6e5b0ba0a37.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0wpfwa64i1h3ga0jafpfh8kqr1nbbkj01r6f920z9fjfwn3xw08y";
})
