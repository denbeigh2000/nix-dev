# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

if [[ -e "$ZSH/oh-my-zsh.sh" ]]
then
    # Set name of the theme to load.
    # Look in ~/.oh-my-zsh/themes/
    ZSH_THEME="steeef"

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    plugins=(git cargo)

    source $ZSH/oh-my-zsh.sh
fi

export GOPATH='/home/denbeigh/dev/go'

# Customize to your needs...
export PATH=$HOME/bin:$HOME/.local/bin:$PATH:$GOPATH/bin

SED_CMD='s/^\(.*\)/sudo \1/g' 
alias fuck="fc -e \"sed -i '$SED_CMD'\""
unset SED_CMD
alias clip='xclip -selection CLIPBOARD $@'

bindkey -v

if command -v nvim >/dev/null
then
    alias vim='nvim'
    export EDITOR='nvim'
elif command -v vim >/dev/null
then
    export EDITOR='vim'
fi

if command -v exa >/dev/null
then
    unalias ls
    alias ls='exa'
fi

if command -v keychain >/dev/null
then
    eval $(keychain --eval --quiet id_rsa)
fi

ZSH_SYNTAX_FILES=(
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
for FILE in $ZSH_SYNTAX_FILES
do
    if [[ -e "$FILE" ]]
    then
        source "$FILE"
        break
    fi
done

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [[ -s "$HOME/.zprofile" ]]
then
    source "$HOME/.zprofile"
fi

INTOXICATED="$(intox_interactive)"
if [[ ! -z $INTOXICATED ]]
then
    export INTOXICATED
fi

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

if [[ $(($RANDOM % 100)) = 0 ]]
then
    echo "\nYou have mail."
fi

if which direnv >/dev/null
then
    eval "$(direnv hook zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# Base16 Gruvbox dark, soft
# Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
_gen_fzf_default_opts() {
    local color00='#32302f'
    local color01='#3c3836'
    local color02='#504945'
    local color03='#665c54'
    local color04='#bdae93'
    local color05='#d5c4a1'
    local color06='#ebdbb2'
    local color07='#fbf1c7'
    local color08='#fb4934'
    local color09='#fe8019'
    local color0A='#fabd2f'
    local color0B='#b8bb26'
    local color0C='#8ec07c'
    local color0D='#83a598'
    local color0E='#d3869b'
    local color0F='#d65d0e'

    export FZF_DEFAULT_OPTS="
      --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
      --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
      --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
    "
}

_gen_fzf_default_opts

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
