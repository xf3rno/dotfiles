# {{{

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then return; fi

# }}}
# {{{ env vars

# {{{ base

export USER=xf3rno
export SHELL=bash
export EDITOR=nvim
export HOME=/home/$USER
export PERSONAL_BIN=$HOME/bin
export PERSONAL_BASH_LIB=$PERSONAL_BIN/bash
export PASSWORD_STORE=$HOME/.password-store

# }}}
# {{{ gh-cli

export GIT_EDITOR=nvim
export GH_EDITOR=nvim
export GH_PAGER=slit
export BROWSER=firefox
export GLAMOUR_STYLE=dark
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

source $HOME/.config/gh/env.sh

# }}}
# {{{ fzf

# {{{ FZF ag (disabled)

export FZF_DEFAULT_COMMAND='ag --hidden --ignore-dir={.git,.undodir,docs/dist,node_modules,bower_components,dist} -g ""'

# }}}
# {{{ FZF fd

# export FZF_DEFAULT_COMMAND='fd --type f'

# }}}

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_BIN=$HOME/.fzf/bin

# }}}
# {{{ tooling

# {{{ rvm/ruby

export RVM_BIN=$HOME/.rvm/bin
export GEM_HOME=$HOME/.rvm/gem/ruby-2.7.0
export GEM_PATH=$GEM_HOME/bin

# }}}
# {{{ go

export GOPATH=$HOME/go
export GOPATH_BIN=$HOME/go/bin

# }}}
# {{{ node/yarn

export NVM_BIN_PATH=$HOME/.nvm/versions/node/v15.3.0/bin
export YARN_BIN=$HOME/.yarn/bin

# }}}
# {{{ rust

export CARGO_PATH=$HOME/.cargo/bin

# }}}

# }}}
# {{{ snap

export SNAP_PATH=/snap/bin

# }}}
# {{{ bin

export USR_BIN=/usr/local/bin
export LOCAL_BIN=$HOME/.local/bin
export ANDROID_STUDIO_BIN=$HOME/bin/android-studio/bin

# }}}
# {{{ pass

source ~/.password-store/.env
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# }}}
# {{{ TERM

export TERM=xterm-256color

# }}}

# }}}
# {{{ shortcuts

# {{{ system

shutdn() {
  shutdown -h -P now
}

kk() {
  sudo killall $@ -9
}

mnt() {
  sudo mount /dev/$@ /mnt
}

umnt() {
  sudo unmount /mnt
}

# }}}
# {{{ shell

x() {
  exit
}

c() {
  clear
}

# }}}
# {{{ ssh

outpost() {
  ssh outpost
}

# }}}
# {{{ git

gs() {
  git status
}

gc() {
  git clone $@
}

gcgh() {
  DEST=~/.src/github/$@

  if [[ -f $DEST ]]; then
    echo "$DEST already exists"
  else
    mkdir -p $DEST

    if [[ $@ == *$USER* ]]; then
      REPO_URL=git@github.com:$@
    else
      REPO_URL=https://github.com/$@
    fi

    git clone $REPO_URL $DEST
  fi

  cd $DEST
}

gcs() {
  git clone --depth=1 $@
}

gp() {
  git push -u origin HEAD
}

gpf() {
  git push -u origin HEAD --force
}

gcam() {
  git commit -am "$@"
}

gcm() {
  git commit -m "$@"
}

gl() {
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s%Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

ga() {
  git add -p $@
}

gd() {
  git diff $@
}

# }}}
# {{{ pass
# TODO: Extract into helper

pcp() {
  pass -c $@
}

# TODO
# pass-gen-otp() {
#   read -p "Enter Seed: " OTP_SECRET
#   read -p "Enter Label: " OTP_LABEL

#   OTP_URL=otpauth://totp/$OTP_LABEL?secret=$OTP_SECRET

#   read -p "Confirm $OTP_URL for $@ (Y/N): " confirm && \
#     [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

#   echo $OTP_URL > pass otp insert $@

#   OTP_CODE=$(pass otp $@)

#   echo "Setup $@: $OTP_CODE"
# }

pass-gen() {
  pass generate $@
  clear
  pass -c $@
  pushd .
  cd $PASSWORD_STORE
  gp
  popd
}

pass-google() {
  # pass otp g/google/otp
  pass -c g/google
}

pass-proton() {
  pass otp s/protonmail/otp
  pass -c s/protonmail
}

pass-github() {
  pass otp g/github/otp
  pass -c g/github
}

pass-twitter() {
  pass otp s/twitter/otp
  pass -c s/twitter
}

# }}}
# {{{ system services

jctl() {
  sudo journalctl -u $@
}

jctlf() {
  sudo journalctl -u $@ -f
}

sysup() {
  sudo systemctl start $@
}

sysdn() {
  sudo systemctl stop $@
}

sysst() {
  sudo systemctl status $@
}

syson() {
  sudo systemctl enable $@
}

sysoff() {
  sudo systemctl disable $@
}

# }}}
# {{{ system packages

pkgi() {
  sudo dnf install -y $@
}

pkgs() {
  sudo dnf search $@
}

pkgu() {
  sudo dnf update -y
}

# }}}
# {{{ tmux

tmn() {
  tmux new -s T
}

tma() {
  tmux attach -t T
}

# }}}
# {{{ pulseaudio

reboot-pa() {
  pulseaudio -k
  pulseaudio --start
}

# }}}
# {{{ utilities

mkexec() {
  chmod +x $@
}

# }}}

# }}}
# {{{ aliases

# convenience
# lsd disabled due to poor visiblity on white bg, no color scheme support
# alias ls="lsd"
# alias ll="lsd -lh"
# alias lah="lsd -lah"
alias ls="ls --color=auto"
alias ll='ls -lah --color=auto'
alias grep='grep --color'
alias cat="bat"
alias vim="nvim"
alias vimbrc="vim ~/.bashrc"
alias xf3rno="ssh xf3rno"

# }}}
# {{{ bookmarks: https://dmitryfrank.com/articles/shell_shortcuts
# cdg (fzf bookmark cd via $HOME/.cdg_paths)
unalias cdg 2> /dev/null

cdg() {
  local dest_dir=$(cdscuts_glob_echo | fzf )

  if [[ $dest_dir != '' ]]; then
    cd "$dest_dir"
  fi
}

export -f cdg > /dev/null
set -o noclobber # prevent redirect overwriting existing files
shopt -s autocd # cd by entering path with no prefix

# }}}
# {{{ plugins/autocomplete

source $HOME/.src/github/alacritty/alacritty/extra/completions/alacritty.bash
source $HOME/.autojump/share/autojump/autojump.bash # cd w/ history
source $HOME/.bash-powerline.sh # prompt
source <(kitty + complete setup bash)
# source $HOME/.npm-completion-fast/npm-completion-fast.bash
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

# Via https://github.com/jez/vim-superman
complete -o default -o nospace -F _man vman

source $HOME/.src/github/gjsheep/bash-wakatime/bash-wakatime.sh
# source $HOME/.node_bash_completion

# }}}
# {{{ path

PATH_MEMBERS=( \
  $RVM_BIN \
  $GOPATH_BIN \
  $YARN_BIN \
  $CARGO_PATH \
  $NVM_BIN_PATH \
  $PERSONAL_BIN \
  $LOCAL_BIN \
  $FZF_BIN \
  $SNAP_PATH \
  $ANDROID_STUDIO_BIN \
)

export PATH="$(printf "%s:" "${PATH_MEMBERS[@]}"):$PATH"

# }}}
# {{{ nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# }}}
# {{{ personal bash lib

# source $PERSONAL_BASH_LIB/lib.sh
