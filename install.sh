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
        alert="\e[0;31m\e[1m[!] "
        var3="${alert}"
        ;;
      s)
        success="\e[0;32m\e[1m[+] "
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
  (ping -c 3 google.com) &> /dev/null 2>&1
  if [[ "${?}" != 0 ]];then
    echo
	  bl -ai "Please Check Your Internet Connection...";
    return 1
  else
    return 0
	fi
}

pkg_install(){
  echo
  _pkg_=${1}
  ping_ok
  bl -si "Installing ${1}..."
  echo -e "\e[0;2m\e[3m"
  apt install ${_pkg_} -y || sudo apt install ${_pkg_} -y
  echo -e "\e[0;m"
}

dnload(){
  _pkg_=$(dpkg -s curl | grep '^Status:')
  _pkg_out="Status: install ok installed"
  if [[ "${_pkg_}"=="${_pkg_out}" ]]; then
    echo -e "\e[0;2m\e[3m"
    curl -OL ${1}
    echo -e "\e[0;m"
  else
    echo
    pkg_install curl && echo && curl -OL ${1}
  fi
}

phase2(){
  if [[ -f "~/.ui/p2.dl" ]]; then
    echo
  else
    echo -e "\e[0;2m\e[3m"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "~/.oh-my-zsh" --depth 1
    if [[ -f "~/.zshrc" ]]; then
      mv "~/.zshrc" "~/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
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
  echo "1" > ~/.ui/p2.dl
  echo -e "\e[0;m"
  bl -s "Please restart your termux app."
  exit
}

phase1(){
  if [[ -e "~/.ui/p1.dl" ]]; then
    echo
  else
    echo
    if [[ -d "~/.termux" ]]; then
      mv "~/.termux" "~/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    dnload "https://github.com/ytstrange/TermUi/blob/main/termux.zip?raw=true"
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
    bl -si "Storage permission is already allowed."
  else
    bl -si "Please allow storage permission !"
    eval "termux-setup-storage"
  fi
  config_files
}

setup_storage