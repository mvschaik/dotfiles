
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
if [[ ! -n "$TMUX" && ( "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ) ]]; then
    PROMPT+="%{$fg[yellow]%}%n@%m%{$reset_color%}:"
fi
PROMPT+='%{$fg[cyan]%}%(4~|…|)%3~%{$reset_color%} '
RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
