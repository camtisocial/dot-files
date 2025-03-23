# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


bind '"\C-y": "\C-l"'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# some more ls aliases
alias ls='lsd'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ,='cd ..'
alias c='clear'
alias pipes='pipes.sh'
alias weather='curl wttr.in'
alias moon='curl wttr.in/moon'
alias moon='curl wttr.in/moon'
alias htop='bpytop'
alias tree='lsd --tree'
alias v='nvim'
alias bye='echo "Bye bye!"; sleep 2; poweroff'
alias audio='flatpak run com.saivert.pwvucontrol'
alias status='systemctl --user status'
alias restart='systemctl --user restart'
alias intercept-on='sudo systemctl enable --now interception.service'
alias intercept-off='sudo systemctl stop interception.service && sudo systemctl disable interception.service'
# alias yz='yazi'
alias day='~/scripts/day.sh'
alias night='~/scripts/night.sh'
alias cs='echo -e "\n"; neofetch --ascii "$(fortune | cowsay -W 30)"'
alias ra='tmux attach-session -t'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#nvm
export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/init-nvm.sh


# pnpm
export PNPM_HOME="/home/cameron/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enabling fzf ctrl-r stuff
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash


eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
[ -f "$HOME/.cache/wal/colors.sh" ] && source "$HOME/.cache/wal/colors.sh"

z() {
    local tmp="$(mktemp)"
    yazi "$@" --cwd-file="$tmp"
    if [ -s "$tmp" ]; then
        cd "$(cat "$tmp")" || return
    fi
    rm -f "$tmp"
}



export PATH="$HOME/.cargo/bin:$PATH"
