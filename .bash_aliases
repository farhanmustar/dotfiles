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
alias ssh-start-agent='eval $(keychain --eval ~/.ssh/<your_key>)'

# windows (wsl) specific
alias pwsh='powershell -Command'

_get_vm_status()
{
  echo "$(pwsh get-vm \| where-object\{\$_.state -eq \"$1\"\} \| select-object -expand name | tr -d "\r")"
}

_pwsh()
{
  local cur prev

  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  case ${COMP_CWORD} in
    1)
      COMPREPLY=($(compgen -W "get-vm start-vm stop-vm suspend-vm resume-vm choco sudo" -- ${cur}))
      ;;
    2)
      case ${prev} in
        start-vm)
          COMPREPLY=($(compgen -W "$(_get_vm_status off)" -- ${cur}))
          ;;
        stop-vm)
          COMPREPLY=($(compgen -W "$(_get_vm_status running)" -- ${cur}))
          ;;
        suspend-vm)
          COMPREPLY=($(compgen -W "$(_get_vm_status running)" -- ${cur}))
          ;;
        resume-vm)
          COMPREPLY=($(compgen -W "$(_get_vm_status paused)" -- ${cur}))
          ;;
      esac
      ;;
    *)
      COMPREPLY=()
      ;;
  esac
}

complete -F _pwsh pwsh
