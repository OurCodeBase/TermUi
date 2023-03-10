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
  if [[ -f "${HOME}/.ui/p2.dl" ]]; then
    echo
    bl -si "Phase2 Already Passed..."
    echo
    exit
  else
    bl -si "Initializing Phase2..."
    {
      echo -e "\e[0;2m\e[3m"
      git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh" --depth 1
      echo
    } && {
      if [[ -e "${HOME}/.zshrc" ]]; then
        mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
      fi
      cp "${HOME}/.oh-my-zsh/templates/zshrc.zsh-template" "${HOME}/.zshrc"
      sed -i '/^ZSH_THEME/d' "${HOME}/.zshrc"
      sed -i '1iZSH_THEME="agnoster"' "${HOME}/.zshrc"
      echo "alias chcolor='${HOME}/.termux/colors.sh'" >> "${HOME}/.zshrc"
      echo "alias chfont='${HOME}/.termux/fonts.sh'" >> "${HOME}/.zshrc"
    } && {
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh-syntax-highlighting" --depth 1
    } && {
      echo "source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${HOME}/.zshrc"
    } && {
      chsh -s zsh
    } && {
      echo -e ""
      chmod +x ${HOME}/.termux/colors.sh
      chmod +x ${HOME}/.termux/fonts.sh
      ${HOME}/.termux/colors.sh
      ${HOME}/.termux/fonts.sh
      echo
      echo "1" >> "${HOME}/ui/p2.dl"
      echo -e "\e[0;m"
      echo -e "Please restart Termux app..."
      echo
      cd
      rm -rf ../usr/etc/motd* &> /dev/null
      exit
    }
  fi
}

phase1(){
  if [[ -f "${HOME}/.ui/p1.dl" ]]; then
    echo
    phase2
  else
    echo
    if [[ -d "${HOME}/.termux" ]]; then
      mv "${HOME}/.termux" "${HOME}/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    dnload "https://github.com/ytstrange/TermUi/blob/main/termux.zip?raw=true"
    echo -e "\e[0;2m\e[3m"
    unzip -d ${HOME} termux.zip
    echo -e "\e[0;m"
    rm termux.zip
    echo "1" > ${HOME}/.ui/p1.dl
    phase2
  fi
}

depends(){
  echo
  pkg_install git
  pkg_install zsh
  phase1
}

config_files(){
  if [[ -d "${HOME}/.ui" ]]; then
    depends
  else
    mkdir ${HOME}/.ui && depends
  fi
}

setup_storage(){
  echo
  if [[ -d "${HOME}/storage/shared" ]]; then
    bl -si "Storage permission is already allowed..."
  else
    bl -si "Please allow storage permission..."
    eval "termux-setup-storage"
  fi
  config_files
}

setup_storage