#!/bin/bash

# Variables
red="\e[0;31m";green="\e[0;32m";blue="\e[0;34m";TermDir="${HOME}/.termux";
alert="\e[0;31m\e[1m[∆]";success="\e[0;32m\e[1m[√]";
pearly="\e[0;2m";enc="\e[0;m";lisence="${TermDir}/lisence.txt";

bl(){
  while getopts 'rgbpfias:h' opt; do
    case "${opt}" in
      r)var3="\e[0;31m";;g)var3="\e[0;32m";;
      b)var3="\e[0;34m";;p)var3="\e[0;2m";;
      f)var3+="\e[1m";;i)var3+="\e[3m";;
      a)var3="\e[0;31m\e[1m[∆] ";;
      s)var3="\e[0;32m\e[1m[√] ";;
      ?|h)
        echo -e "\e[1mUsage: \e[0;m";
        echo -e " -r  red\n -g  green\n -b  blue\n -p  pearly<Grey>
 -f  fearless<Bold>\n -i  italic\n -a  alert\n -s  success";return 1;;
    esac
  done
  if [[ -z "${2}" ]]; then echo -e "\e[0;32m\e[3m\e[1m[√] Hello World\e[0;m";return 1;
  else echo -e "${var3}${2}\e[0;m";return 0;fi
}

is_userland(){
  (cd /host-rootfs/data/data/tech.ula/files/home) &> /dev/null 2>&1;
  if [[ "${?}" != 0 ]]; then return 1;else return 0;fi
}

pkg_build(){
  local pkg_info=${1};
  echo;bl -s "Installing ${pkg_info}...";echo -e "${pearly}${pearly}";
  if is_userland; then sudo apt install "${pkg_info}" -y;
  else apt-get install "${pkg_info}" -y;fi
  if [[ "${?}" != 0 ]]; then echo;bl -a "Package Installation Failed...";echo;exit;fi
  echo -ne "${enc}";return 0;
}

dnrepo(){
  local _repo_link=${1};local _file_link="${2}";local prova="git clone https://github.com/"; # prova = process variable
  if [[ -z "${_repo_link}" ]]; then echo;bl -a "Repository parameter is Empty...";echo;return 1;fi
  if [[ -z "${_file_link}" ]]; then echo;bl -a "File parameter is Empty...";echo;return 1;fi
  prova+="${_repo_link}.git ${_file_link} --depth 1";
  echo;bl -s "Cloning ${_repo_link}...";echo -e "${pearly}";eval "${prova}";
  if [[ "${?}" != 0 ]]; then echo;bl -a "Repository Download Failed...";echo;exit;fi
  echo -ne "${enc}";return 0;
}

banner(){
  echo "
╔═╗╔╦╗╦═╗╔═╗╔╗╔╔═╗╔═╗
╚═╗ ║ ╠╦╝╠═╣║║║║ ╦║╣ 
╚═╝ ╩ ╩╚═╩ ╩╝╚╝╚═╝╚═╝
  ";
  echo "Start coding with yourself.";echo "---------------------------";
}

lisence_exist(){
  if [[ ! -f "${lisence}" ]]; then return 1;fi
  if [[ $(cat ${lisence}) == *"Author:Harsh B"* ]]; then return 0;else return 1;fi
}

TermDir_Download(){
  if [[ -d "${TermDir}" ]]; then mv "${TermDir}" "${TermDir}.bak.$(date +%Y.%m.%d-%H:%M:%S)";fi
  if [[ ! -f "TermUi.zip" ]]; then
    local prova="wget https://github.com/OurCodeBase/TermUi/raw/main/TermUi.zip";
    echo;bl -s "Downloading File...";echo -e "${pearly}${pearly}";(eval "${prova}");
    if [[ "${?}" != 0 ]]; then echo;bl -a "Download Failed...";echo;exit;fi
    echo -e "${enc}";
  else echo;fi
  bl -s "Unpacking Files...";echo -e "${pearly}";(unzip -d ${HOME} TermUi.zip);
  if [[ "${?}" != 0 ]]; then echo;bl -a "Unpacking Failed...";echo;exit;fi
  echo -ne "${enc}";rm TermUi.zip;echo "TermDir:True" >> ${lisence};return 0;
}

install_zsh_syntax(){
  if ! lisence_exist; then TermDir_Download;fi
  if [[ $(cat ${lisence}) != *"zsh_syntax:True"* ]]; then
    if [[ ! -d "${HOME}/.zsh-syntax-highlighting" ]]; then
    dnrepo "zsh-users/zsh-syntax-highlighting" "${HOME}/.zsh-syntax-highlighting";fi
    echo "source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${HOME}/.zshrc";
    echo "zsh_syntax:True" >> ${lisence};
    echo;bl -s "Please restart your session...";echo;doend;
  else echo;bl -s "Zsh Syntax Highlighting is already installed...";echo;doend;fi
}

install_ohmyzsh(){
  if ! lisence_exist; then TermDir_Download;fi
  if [[ $(cat ${lisence}) != *"ohmyzsh:True"* ]]; then
    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    pkg_build git;dnrepo "ohmyzsh/ohmyzsh" "${HOME}/.oh-my-zsh";fi
    if [[ -f "${HOME}/.zshrc" ]]; then
    mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)";fi
    cp "${HOME}/.oh-my-zsh/templates/zshrc.zsh-template" "${HOME}/.zshrc";
    echo "ohmyzsh:True" >> ${lisence};fi
  local theme_array=();cd "${HOME}/.oh-my-zsh/themes";
  for file in *.zsh-theme ; do theme_array=(${theme_array[@]} "${file}");done;local i=0;
  cd;echo;for obj in ${theme_array[@]} ; do obj=${obj/".zsh-theme"/};echo "[$((i++))] ${obj}";done;
  echo;read -p ">> " choice;
  if [[ "${choice}" -ge "${#theme_array[@]}" ]]; then
  echo;bl -a "Invalid Input...";echo;return 1;fi
  sed -i '/^ZSH_THEME/d' "${HOME}/.zshrc";local var4='1iZSH_THEME="index"';
  local var5=${var4/"index"/"${theme_array[${choice}]}"};local var6=${var5/".zsh-theme"/};
  sed -i "${var6}" "${HOME}/.zshrc";
  echo;bl -s "Please restart your session...";echo;
  unset file obj choice theme_array;return 0;
}

install_zsh(){
  if ! lisence_exist; then TermDir_Download;fi
  if [[ $(cat ${lisence}) == *"zsh:True"* ]]; then
  echo;bl -s "Zsh is already installed...";echo;exit;
  else pkg_build zsh;
    if is_userland; then
    echo "su" >> home/user/.bashrc;echo "zsh" >> /root/.bashrc;
    mv "/home/user/.termux" "/root/" &> /dev/null;
    if [[ ${?} == 0 ]]; then echo "zsh:True" >> ${lisence};fi
    echo;bl -s "Please restart your Userland session...";echo;doend;return 0;
    else chsh -s zsh;
    if [[ ${?} == 0 ]]; then echo "zsh:True" >> ${lisence};fi
    echo;bl -s "Please restart your Termux session...";echo;doend;return 0;
    fi
  fi
}

install_color(){
  if ! lisence_exist; then TermDir_Download;starter;return 1;fi
  echo;local color_array=();cd "${TermDir}/colors";local i=0;
  for file in *.properties ; do color_array=(${color_array[@]} "${file}");done;cd;
  for obj in ${color_array[@]} ; do
  obj=${obj/".properties"/};echo "[$((i++))] ${obj}";done;
  echo;read -p ">> " choice;
  if [[ "${choice}" -ge "${#color_array[@]}" ]]; then
  echo;bl -a "Invalid Input...";echo;return 1;fi
  if is_userland; then
  local hostdir="/host-rootfs/data/data/tech.ula/files/home";mkdir -p ${hostdir}/.termux;
  (yes | cp -f "${TermDir}/colors/${color_array[${choice}]}" "${hostdir}/.termux/colors.properties") &> /dev/null;
  echo;bl -s "Please restart Userland session...";echo;
  unset file obj choice;return 0;
  else yes | cp "${TermDir}/colors/${color_array[${choice}]}" "${TermDir}/colors.properties";
  eval "termux-reload-settings";echo;
  echo;bl -s "Please restart Termux session...";echo;
  unset file obj choice;return 0;fi
}

install_font(){
  if ! lisence_exist; then TermDir_Download;starter;return 1;fi
  echo;local font_array=();cd "${TermDir}/fonts";local i=0;
  for file in *.ttf ; do font_array=(${font_array[@]} "${file}");done;cd;
  for obj in ${font_array[@]} ; do
  local obj=${obj/".ttf"/};echo "[$((i++))] ${obj}";done;
  echo;read -p ">> " choice;
  if [[ "${choice}" -ge "${#font_array[@]}" ]]; then
  echo;bl -a "Invalid Input...";echo;return 1;fi
  if is_userland; then
  local hostdir="/host-rootfs/data/data/tech.ula/files/home";mkdir -p ${hostdir}/.termux;
  (yes | cp -f "${TermDir}/fonts/${font_array[${choice}]}" "${hostdir}/.termux/font.ttf") &> /dev/null;
  echo;bl -s "Please restart Userland session...";echo;
  unset file obj choice;return 0;
  else yes | cp "${TermDir}/fonts/${font_array[${choice}]}" "${TermDir}/font.ttf";
  eval "termux-reload-settings";echo;
  echo;bl -s "Please restart Termux session...";echo;
  unset file obj choice;return 0;fi
}

doend(){
  unset red green blue success alert;
  unset pearly TermDir lisence enc var3;
  unset funcs choice;
  exit;
}

starter(){
  cd;banner;local i=0;echo;
  echo "[0] Install Fonts";echo "[1] Install Colors";
  echo "[2] Install Zsh";echo "[3] Install OhMyZsh";
  echo "[4] Install Zsh Syntax Highlighting"
  echo "[5] Exit";echo;read -p ">> " choice;
  case ${choice} in
    0)install_font;;1)install_color;;
    2)install_zsh;;3)install_ohmyzsh;;4)install_zsh_syntax;;
    5)echo;doend;;
    *)echo;bl -a "Invalid Input...";echo;return 1;;esac
}

starter
