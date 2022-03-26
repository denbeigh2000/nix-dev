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

  vimPlugins = with pkgs.vimPlugins; [
    LanguageClient-neovim
    nvim-yarp
    ncm2
    vim-gitgutter
    vim-rooter
    incsearch-vim
    fzf-vim
    suda-vim
    committia-vim
    vim-fugitive
    vim-git
    vim-airline
    taglist-vim
    indentLine
    vim-toml
    csv-vim
    vim-scala
    vim-go
    vim-nix
    vim-jsx-typescript
    vim-javascript
    ansible-vim
    vim-markdown
    vim-puppet
    arcanist-vim
    vim-protobuf
    kotlin-vim
    gruvbox
  ];
}
