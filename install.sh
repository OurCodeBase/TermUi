#/bin/bash

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

pkg_build(){
  pkg_info=${1};
  if [[ -z "${pkg_info}" ]]; then echo;bl -a "Package parameter is Empty...";echo;return 1;fi
  (ping -c 3 google.com) &> /dev/null 2>&1;
  if [[ "${?}" != 0 ]]; then echo;bl -a "Internet Connection Error...";echo;exit;fi
  _pkg_var2=$(eval "apt search ${pkg_info} 2> /dev/null");
  if [ "${_pkg_var2}" != *"stable"* ] || [ "${_pkg_var2}" != *"rolling"* ]; then echo;bl -a "Package does not Exist...";echo;return 1;fi
  echo;bl -s "Installing ${pkg_info}...";echo -e "${pearly}${pearly}";
  (eval "apt-get install ${pkg_info} -y" || eval "sudo apt-get install ${pkg_info} -y");echo -e "${enc}";return 0;
}

dnrepo(){
  _repo_link=${1};_file_link="${2}";prova="git clone https://github.com/"; # prova = process variable
  if [[ -z "${_repo_link}" ]]; then echo;bl -a "Repository parameter is Empty...";echo;return 1;fi
  if [[ -z "${_file_link}" ]]; then echo;bl -a "File parameter is Empty...";echo;return 1;fi
  (ping -c 3 google.com) &> /dev/null 2>&1;
  if [[ "${?}" != 0 ]]; then echo;bl -a "Internet Connection Error...";echo;return 1;fi
  prova+="${_repo_link}.git ${_file_link} --depth 1";
  echo;bl -s "Cloning ${_repo_link}...";echo -e "${pearly}";
  eval "${prova}";echo -e "${enc}";return 0;
}

banner(){
  echo "
╔═╗╔╦╗╦═╗╔═╗╔╗╔╔═╗╔═╗
╚═╗ ║ ╠╦╝╠═╣║║║║ ╦║╣ 
╚═╝ ╩ ╩╚═╩ ╩╝╚╝╚═╝╚═╝
  ";
  echo "Start coding with yourself.";
  echo "___________________________";
}

is_userland(){
  (cd /host-rootfs/data/data/tech.ula/files/home) &> /dev/null 2>&1;
  if [[ "${?}" != 0 ]]; then return 1;else return 0;fi
}

lisence_exist(){
  if [[ ! -f "${lisence}" ]]; then return 1;fi
  if [[ $(cat ${lisence}) == *"Author:Harsh B"* ]]; then return 0;else return 1;fi
}

# Userland needs iputils-ping package

TermDir_Download(){
  if [[ -d "${TermDir}" ]]; then mv "${TermDir}" "${TermDir}.bak.$(date +%Y.%m.%d-%H:%M:%S)";fi
  (ping -c 3 google.com) &> /dev/null 2>&1;
  if [[ "${?}" != 0 ]]; then echo;bl -a "Internet Connection Error...";echo;return 1;fi
  prova="curl -OL https://github.com/strangecode4u/TermUi/raw/main/TermUi.zip";
  echo;bl -s "Downloading File...";echo -e "${pearly}${pearly}";(eval "${prova}");echo -e "${enc}";
  bl -s "Unpacking Files...";echo -e "${pearly}";(unzip -d ${HOME} TermUi.zip);echo -e "${enc}"
  rm TermUi.zip;echo "TermDir:True" >> ${lisence};starter;return 0;
}

install_ohmyzsh(){
  pkg_build git;
  dnrepo "ohmyzsh/ohmyzsh" "${HOME}/.oh-my-zsh";
  if [[ -e "${HOME}/.zshrc" ]]; then
  mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)";fi
  cp "${HOME}/.oh-my-zsh/templates/zshrc.zsh-template" "${HOME}/.zshrc";
  sed -i '/^ZSH_THEME/d' "${HOME}/.zshrc";
  sed -i '1iZSH_THEME="agnoster"' "${HOME}/.zshrc";
}

install_zsh(){
  pkg_build zsh;
  if is_userland; then
    echo "su" >> ~/.bashrc;echo "zsh" >> /root/.bashrc;
    bl -s "Please restart your Userland session...";echo;
  else chsh -s zsh;
    bl -s "Please restart your Termux session...";echo;
  fi
}

install_color(){
  if ! lisence_exist; then TermDir_Download;return 1;fi
  echo;color_array=();cd "${TermDir}/colors";let i=0;
  for file in *.properties ; do color_array=(${color_array[@]} "${file}");done;cd;
  for obj in ${color_array[@]} ; do
  obj=${obj/".properties"/};echo "[$((i++))] ${obj}";done;
  echo;read -p ">> " choice;
  if [[ "${choice}" -ge "${#color_array[@]}" ]]; then
  echo;bl -a "Invalid Input...";echo;return 1;fi
  if is_userland; then
    hostdir="/host-rootfs/data/data/tech.ula/files/home";mkdir -p ${hostdir}/.termux;
    (yes | cp -f "${TermDir}/colors/${color_array[${choice}]}" "${hostdir}/.termux/colors.properties") &> /dev/null;
    echo;bl -s "Please restart your Userland session...";echo;
  else
    yes | cp "${TermDir}/colors/${color_array[${choice}]}" "${TermDir}/colors.properties";
    eval "termux-reload-settings";
    echo;bl -s "Please restart your Termux session...";echo;return 0;
  fi
}

install_font(){
  if ! lisence_exist; then TermDir_Download;starter;return 1;fi
  echo;font_array=();cd "${TermDir}/fonts";let i=0;
  for file in *.ttf ; do font_array=(${font_array[@]} "${file}");done;cd;
  for obj in ${font_array[@]} ; do
  obj=${obj/".ttf"/};echo "[$((i++))] ${obj}";done;
  echo;read -p ">> " choice;
  if [[ "${choice}" -ge "${#font_array[@]}" ]]; then
  echo;bl -a "Invalid Input...";echo;return 1;fi
  if is_userland; then
    hostdir="/host-rootfs/data/data/tech.ula/files/home";mkdir -p ${hostdir}/.termux;
    (yes | cp -f "${TermDir}/fonts/${font_array[${choice}]}" "${hostdir}/.termux/font.ttf") &> /dev/null;
    echo;bl -s "Please restart your Userland session...";echo;return 0;
  else
    yes | cp "${TermDir}/fonts/${font_array[${choice}]}" "${TermDir}/font.ttf";
    eval "termux-reload-settings";echo;bl -s "Please restart your Termux session...";echo;return 0;
  fi
}

starter(){
  cd;banner;let i=0;echo;
  funcs_array=("Font" "Colour" "Zsh" "Zsh_Syntax_Highlighting" "OhMyZsh");
  for funcs in ${funcs_array[@]} ; do echo "[$((i++))] Install ${funcs}";done;
  echo;read -p ">> " choice;
  case ${choice} in
    0)install_font;;1)install_color;;
    2)install_zsh;;3)install_zsh_syntax;;4)install_ohmyzsh;;
    *)echo;bl -a "Invalid Input...";echo;return 1;;esac
}

starter