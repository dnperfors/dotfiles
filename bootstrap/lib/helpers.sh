#!/bin/sh
###
# some bash/zsh library helpers
# @author Adam Eivy
###

# colors
# ESC_SEQ="\x1b["
# col_reset=$ESC_SEQ"39;49;00m"
# col_red=$ESC_SEQ"91;01m"
# col_green=$ESC_SEQ"92;01m"
# col_yellow=$ESC_SEQ"93;01m"
# col_blue=$ESC_SEQ"94;01m"
# col_magenta=$ESC_SEQ"95;01m"
# col_cyan=$ESC_SEQ"96;01m"

ESC_SEQ="\x1b["
col_reset=$ESC_SEQ"39;49;00m"
col_red=$ESC_SEQ"31;01m"
col_green=$ESC_SEQ"32m"
col_yellow=$ESC_SEQ"33m"
col_blue=$ESC_SEQ"34m"
col_magenta=$ESC_SEQ"35m"
col_cyan=$ESC_SEQ"36m"

function ok() {
    echo -e "$col_green[ok]$col_reset "$1
}

function running() {
    echo -e "\n$col_blue\[._.]/$col_reset - "$1
}

function log() {
    echo -e "$col_yellow ⇒ $col_reset"$1": "
}

function action() {
    echo -e "\n$col_cyan[action]:$col_reset\n ⇒ $1..."
}

function warn() {
    echo -e "$col_yellow[warning]$col_reset "$1
}

function error() {
    echo -e "$col_red[error]$col_reset "$1
}

function promptSudo(){
    # Ask for the administrator password upfront
    running "I need you to enter your sudo password so I can install some things:"
    sudo -v

    # Keep-alive: update existing sudo time stamp until the script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}


function symlinkifne {
    running "$1"

    if [[ -e $1 ]]; then
        # file exists
        if [[ -L $1 ]]; then
            # it's already a simlink (could have come from this project)
            echo -en '\tsimlink exists, skipped\t';ok
            return
        fi
        # backup file does not exist yet
        if [[ ! -e ~/.dotfiles_backup/$1 ]];then
            mv $1 ~/.dotfiles_backup/
            echo -en 'backed up saved...';
        fi
    fi
    # create the link
    ln -s ~/.dotfiles/$1 $1
    echo -en '\tlinked';ok
}

function ask(){
  if [ ! -z "$FULL_RUN" ]; then
    return 0
  fi

  response=1
  action "Do you want to $1 (y/N)"
  read -n 1 answer

  if [ $answer == "y" ]; then
    response=0
  fi
  return $response
}

function zsh(){
  echo $0 | grep zsh > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    return 1
  else
    return 0
  fi
}
