# ====== ZINIT SETUP ======
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
    mkdir -p ~/.zinit
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# ====== PLUGINS ======
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light marlonrichert/zsh-autocomplete

autoload -Uz compinit && compinit

# ====== ENHANCED PROMPT ======
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{blue}(%b)%f'
zstyle ':vcs_info:git:*' actionformats '%F{blue}(%b)%f %F{red}[%a]%f'

precmd() { 
    vcs_info
    if [[ -n ${vcs_info_msg_0_} ]]; then
        if git diff --cached --quiet 2>/dev/null; then
            staged=""
        else
            staged="%F{green}+%f"
        fi
        
        if git diff --quiet 2>/dev/null; then
            unstaged=""
        else
            unstaged="%F{red}!%f"
        fi
        
        if [[ -z $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
            untracked=""
        else
            untracked="%F{cyan}?%f"
        fi
        
        git_status="${staged}${unstaged}${untracked}"
    fi
}

setopt prompt_subst
PROMPT='%F{yellow}%n%f@%F{red}%m%f %F{green}%~%f ${vcs_info_msg_0_}${git_status}$ '

# ====== HISTORY SETTINGS ======
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_VERIFY

# ====== BEHAVIOR SETTINGS ======
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NO_CASE_GLOB

# ====== COMPLETION SETTINGS ======
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%f %d'
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# ====== KEY BINDINGS ======
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^F' forward-word
bindkey '^[[C' forward-char
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^L' clear-screen

# ====== AUTO-SUGGESTIONS CONFIGURATION ======
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ====== SYNTAX HIGHLIGHTING CONFIGURATION ======
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
ZSH_HIGHLIGHT_STYLES[string]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

alias vim="nvim"
alias ufetch="source ~/.config/scripts/ufetch"
alias ls='ls --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'

has() {
    command -v "$1" >/dev/null 2>&1
}

# ====== ENVIRONMENT VARIABLES ======
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R -X -F"
export LESSHISTFILE="/dev/null"
