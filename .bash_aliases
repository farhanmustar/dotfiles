ssh-agent-start() {
  if [[ -z "$SSH_AGENT_PID" ]]; then
      if [[ $(pgrep ssh-agent) ]]; then
          export SSH_AGENT_PID=$(pgrep ssh-agent)
          echo "Found existing ssh-agent PID, SSH_AGENT_PID=${SSH_AGENT_PID}"
      else
        echo "Starting fresh ssh agent"
        eval `ssh-agent`
      fi
  else
    echo "Existing ssh-agent PID, SSH_AGENT_PID=${SSH_AGENT_PID}"
  fi
}

shopt -s expand_aliases
alias ls='ls --color=auto'
alias sl='ls'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias dua='du -sch .[!.]* * |sort -h'
alias vimod='set -o vi'
alias novimod='set -o emacs'
alias start='xdg-open'
alias open='xdg-open'
alias ssh-basic='ssh -X -A -L 8080:localhost:80'
alias ssh='ssh -X -A'
alias vimg='vim -c GV -c "silent! G" -c "silent! tabonly"'
alias catkin_make_compile_commands='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
alias watchexec='f(){ watch -n1 "watch -t -g ls --full-time \"$1\" >/dev/null && $2"; unset -f f;}; f'

# windows (wsl) specific
alias pwsh='powershell -Command'
