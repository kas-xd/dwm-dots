function fish_prompt
    set -l user (whoami)
    set -l host_name $hostname
    set -l pwd (prompt_pwd)
    # Get git branch if in a git repository
    set -l git_branch ""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -n "$git_branch"
            set git_branch "($git_branch)"
        end
    end
    # Colors: yellow for user, red for hostname, green for pwd
    printf '%s%s%s@%s%s%s %s%s%s %s$ ' \
        (set_color yellow) $user (set_color normal) \
        (set_color red) $host_name (set_color normal) \
        (set_color green) $pwd (set_color normal) \
        $git_branch
end

set fish_greeting ""

alias vim="nvim"
alias ufetch="source ~/.config/scripts/ufetch"
