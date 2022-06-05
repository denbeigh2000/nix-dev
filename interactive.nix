{ pkgs ? import ./pkgs.nix {} }:

{
  base = with pkgs; [
    ctags
    docker
    docker-compose
    fzf
    fzf-zsh
    git
    jq
    less
    man
    oh-my-zsh
    # needed for fzf
    perl
    ripgrep
    screen
    tmux
    watch
    wget
    zsh
  ];

  container = with pkgs; [
    coreutils-full
    gnutar
    gnused
    gnugrep
    nix
  ];
}
