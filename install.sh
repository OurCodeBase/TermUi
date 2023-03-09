#!/bin/bash

bl(){
  while getopts 'rgbpfias:h' opt; do
    case "${opt}" in
      r)
        red="\e[0;31m"
        var3="${red}"
        ;;
      g)
        green="\e[0;32m"
        var3="${green}"
        ;;
      b)
        blue="\e[0;34m"
        var3="${blue}"
        ;;
      p)
        pearly="\e[0;2m"
        var3="${blue}"
        ;;
      f)
        fearless="\e[1m"
        var3+="${fearless}"
        ;;
      i)
        italic="\e[3m"
        var3+="${italic}"
        ;;
      a)
        alert="\e[0;31m[!q] "
        var3="${alert}"
        ;;
      s)
        success="\e[0;32m[+] "
        var3="${success}"
        ;;
      ?)
        enc="\e[0;m"
        fearless="\e[1m"
        echo -e "${fearless} Usage:${enc}
  -r  red
  -g  green
  -b  blue
  -p  pearly<Grey>
  -f  fearless<Bold>
  -i  italic
  -a  alert
  -s  success"
        exit 1
        ;;
    esac
  done
  if [[ -z "${2}" ]]; then
    enc="\e[0;m"
    fearless="\e[1m"
    echo -e "${fearless}Hello World ${enc}"
  else
    enc="\e[0;m"
    echo -e "${var3}${2}${enc}"
  fi
}

ping_ok(){
  ping_=$(ping -c 3 "cutt.ly")
  _ping_="ping: unknown host cutt.ly"
  if [[ "${ping_}"=="${_ping_}" ]]; then
    return 0
  else
    return 1
  fi
}

pkg_install(){
  echo
  if [[ ping_ok ]]; then
    echo
    bl -s "Installing ${1}..."
    echo
    {
      _pkg_="apt install ${1} -y"
      eval=${_pkg_}
    }||{
      _pkg_="sudo apt install ${1} -y"
      eval=${_pkg_}
    }
  else
    echo
    bl -a "Please check your Internet Connection."
    echo
    exit 1
  fi
}

dnload(){
  _pkg_=$(dpkg -s curl | grep '^Status:')
  _pkg_out="Status: install ok installed"
  if [[ "${_pkg_}"=="${_pkg_out}" ]]; then
    echo
    curl -OL ${1}
  else
    echo
    pkg_install curl && echo && curl -OL ${1}
  fi
}

phase2(){
  if [[ -f "~/.ui/p2.dl" ]]; then
    echo
  else
    echo
    git clone https://github.com/ohmyzsh/ohmyzsh.git "~/.oh-my-zsh" --depth 1
    if [[ -f "~/.zshrc" ]]; then
      mv "~/.zshrc" "~/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
  cp "~/.oh-my-zsh/templates/zshrc.zsh-template" "~/.zshrc"
  sed -i '/^ZSH_THEME/d' "~/.zshrc"
  sed -i '1iZSH_THEME="agnoster"' "~/.zshrc"
  echo "alias chcolor='~/.termux/colors.sh'" >> "~/.zshrc"
  echo "alias chfont='~/.termux/fonts.sh'" >> "~/.zshrc"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "~/.zsh-syntax-highlighting" --depth 1
  echo "source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "~/.zshrc"
  chsh -s zsh
  chmod +x ~/.termux/colors.sh
  bash ~/.termux/colors.sh
  chmod +x ~/.termux/fonts.sh
  bash ~/.termux/fonts.
  rm -rf ../usr/etc/motd* &> /dev/null
  echo
  bl -s "Please restart your termux app."
  fi
}

phase1(){
  if [[ -f "~/.ui/p1.dl" ]]; then
    echo
  else
    echo
    if [[ -d "~/.termux" ]]; then
      mv "~/.termux" "~/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    dnload "https://github.com/strangecode4u/TermUi/blob/main/termux.zip?raw=true"
    unzip -d ${HOME} termux.zip
    rm termux.zip
    echo "1" >> ~/.ui/p1.dl
    phase2
  fi
  phase2
}

depends(){
  echo
  pkg_install git
  pkg_install zsh
  phase1
}

config_files(){
  if [[ -d "~/.ui" ]]; then
    depends
  else
    mkdir ~/.ui && depends
  fi
}

setup_storage(){
  echo
  if [[ -d "~/storage/shared" ]]; then
    bl -s "Storage permission is already allowed."
  else
    bl -a "Please allow storage permission !"
    eval "termux-setup-storage"
  fi
  config_files
}

starts(){
  pkg_install curl
  dnload "https://raw.githubusercontent.com/strangecode4u/TermUi/main/assets/colors.properties"
  dnload "https://github.com/strangecode4u/TermUi/blob/main/assets/font.ttf?raw=true"
  if [[ -d "~/.termux" ]]; then
    mv -f colors.properties ~/.termux/
    mv -f font.ttf ~/.termux/
  else
    mkdir ~/.termux
    mv colors.properties ~/.termux/
    mv font.ttf ~/.termux/
  fi
  eval="termux-reload-settings"
  setup_storage
}
starts
