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
  return 1
}

ping_ok(){
  (ping -c 3 google.com) &> /dev/null 2>&1
  if [[ "${?}" != 0 ]];then
    echo
	  bl -ai "Please Check Your Internet Connection...";
    return 0 # return true
  else
    return 1 # return false
	fi
}

# Process --install figlet "Install Figlet"

Process(){
  process_func=${1} # install,git clone,dnload
  process_args=${2} # args for install,git clone,dnload
  process_identity=${3} # args for name
  if [[ -z "${process_func}" ]]; then
    exit
  elif [[ -z ${process_args} ]]; then
    exit
  elif [[ -z ${process_identity} ]]; then
    exit
  fi
  if ping_ok; then
    exit
  fi
  # args variable for Process
  # process_variable=""
  case ${process_func} in
    --install)
      process_variable=""
      _build_pkg_var1=$(pwd)
      _build_pkg_var2="com.termux"
      if [[ ${_build_pkg_var1==*"${_build_pkg_var2}"*} ]]; then
        process_variable+="apt-get install "
      else
        process_variable+="sudo apt-get install "
      fi
      process_variable+="${process_args}"
      process_variable+=" -y &> /dev/null"
      # process_variable has apt
      # eval "${process_variable}" || exit
      ;;
    --gitcl)
      process_variable=""
      process_variable+="git clone"
      process_variable+=" ${process_args}"
      gitcl_file="${process_identity}"
      process_identity="${4}"
      process_variable+=" ${gitcl_file}"
      process_variable+=" --depth 1"
      process_variable+=" &> /dev/null"
      # eval "${process_variable}" ||
      ;;
    --dnload)
      process_variable=""
      process_variable+="curl -OL "
      process_variable+="${process_args}"
      process_variable+=" &> /dev/null"
      # eval "${process_variable}" || exit
      ;;
    --unzip)
      process_variable=""
      process_variable+=" -d ~/"
      process_variable+=" ${process_args}"
      process_variable+=" &> /dev/null"
      process_variable="unzip -d ${HOME}/ TermUi.zip &> /dev/null"
      # eval "${process_variable}" || exit
      ;;
    *)
      exit
      ;;
  esac
  count=0
  total=34
  pstr="[======================================]"
  echo
  bl -si "${process_identity}"
  echo
  while [ $count -lt $total ]; do
    eval ${process_variable}
    count=$(( $count + 1 ))
    pd=$(( $count * 73 / $total ))
    printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
  done
  echo
  return 1
}

phase2(){
  if [[ -f "${HOME}/.ui/p2.dl" ]]; then
    echo
    exit
  else
    bl -si "Initializing Phase2..."
    {
      echo -e "\e[0;2m\e[3m"
      Process --gitcl "https://github.com/ohmyzsh/ohmyzsh.git" "${HOME}/.oh-my-zsh" "Downloading OhMyZsh"
      Process --gitcl "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${HOME}/.zsh-syntax-highlighting" "Downloading zsh-syntax-highlighting"
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
      echo "source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${HOME}/.zshrc"
    } && {
      chsh -s zsh
    } && {
      chmod +x ${HOME}/.termux/colors.sh
      chmod +x ${HOME}/.termux/fonts.sh
      echo -e "\e[0;m"
      ${HOME}/.termux/colors.sh
      ${HOME}/.termux/fonts.sh
      echo
      echo "1" >> "${HOME}/.ui/p2.dl"
      bl -si "Please restart Termux app..."
      rm -rf ${HOME}/../usr/etc/motd* &> /dev/null
      echo
      exit
    }
  fi
}

phase1(){
  if [[ -f "${HOME}/.ui/p1.dl" ]]; then
    phase2
  else
    echo
    if [[ -d "${HOME}/.termux" ]]; then
      mv "${HOME}/.termux" "${HOME}/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    Process --dnload "https://github.com/strangecode4u/TermUi/raw/main/TermUi.zip" "Downloading TermUi"
    echo -e "\e[0;2m\e[3m"
    Process --unzip "TermUi.zip" "Extracting TermUi"
    echo -e "\e[0;m"
    rm TermUi.zip
    echo "1" > ${HOME}/.ui/p1.dl
    phase2
  fi
}

depends(){
  Process --install git "Installing Git"
  Process --install zsh "Installing Zsh"
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
  clear
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