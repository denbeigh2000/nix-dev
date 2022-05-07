import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "rust-overlay-2022-05-07";
  url = "https://github.com/oxalica/rust-overlay/archive/43f4c4319fd29d07912a65d405ff03069c7748c4.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0301x86j0m49c4sf22c9fiyigsn9a4k4bhwmaxvw6yiz2qnqyg0k";
})
