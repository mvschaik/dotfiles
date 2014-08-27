setprompt() {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local      _RESET="\[\033[0;0m\]"
  local    TITLEBAR="\[\033]0;"
  local ENDTITLEBAR="\007\]"

  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM=verbose
  PS1="$TITLEBAR\h:\w$ENDTITLEBAR$LIGHT_GRAY\$(exit=\$?; if [[ \$exit != 0 ]]; then echo \"$LIGHT_RED✗ \$exit\"; fi)$LIGHT_GREEN\$(__git_ps1)$_RESET\u@\h:\w \\$ "
  PS2='> '
  PS4='+ '
}
setprompt

