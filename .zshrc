# zinit
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
    mkdir -p ~/.zinit
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# plugins
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light marlonrichert/zsh-autocomplete

# completions
autoload -Uz compinit
compinit -C

# prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{blue}(%b)%f'

precmd() { vcs_info }

setopt prompt_subst
PROMPT='%F{green}%~%f${vcs_info_msg_0_} $ '

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# behavior
setopt AUTO_CD
setopt EXTENDED_GLOB

# keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# environment
export EDITOR="nvim"
export VISUAL="nvim"

# aliases
alias vim="nvim"
alias ls='ls --color=auto'
