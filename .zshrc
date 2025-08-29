# Zinit
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
    mkdir -p ~/.zinit
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting

# Prompt
autoload -Uz vcs_info
precmd() { vcs_info }
setopt prompt_subst
PROMPT='%F{yellow}%n%f@%F{red}%m%f %F{green}%~%f ${vcs_info_msg_0_}$ '
zstyle ':vcs_info:git:*' formats '(%b)'

# Aliases
alias dwmi="cd /home/kas/dwm;sudo make clean install"
alias dwmc="vim /home/kas/dwm"
