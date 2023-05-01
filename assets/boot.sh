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

banner(){
  echo "
╔═╗╔╦╗╦═╗╔═╗╔╗╔╔═╗╔═╗
╚═╗ ║ ╠╦╝╠═╣║║║║ ╦║╣ 
╚═╝ ╩ ╩╚═╩ ╩╝╚╝╚═╝╚═╝
  ";
  echo "Start coding with yourself.";echo "---------------------------";
}

phase2(){
  echo;bl -s "Cloning...";echo;
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1;
  if [[ -f "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)";fi
  cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc";
  sed -i '/^ZSH_THEME/d' "$HOME/.zshrc";
  sed -i '1iZSH_THEME="agnoster"' "$HOME/.zshrc";
  echo "alias chcolor='$HOME/.termux/colors.sh'" >> "$HOME/.zshrc";
  echo "alias chfont='$HOME/.termux/fonts.sh'" >> "$HOME/.zshrc";
  echo;bl -s "Cloning...";echo;
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1;
  echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc";
  chsh -s zsh;rm -rf ../usr/etc/motd* &> /dev/null;
  bl -a "Successfully completed...";
  echo "zsh_syntax:True" >> ${lisence};
  echo "ohmyzhs:True" >> ${lisence};exit;
}

phase1(){
  echo;bl -s "Downloading Files...";echo;
  wget https://raw.githubusercontent.com/OurCodeBase/TermUi/main/assets/colors.properties;
  wget https://github.com/OurCodeBase/TermUi/blob/main/assets/font.ttf?raw=true;
  if [[ ${?} == 1 ]]; then
  echo;bl -a "Downloading Failed...";return 1;fi
  if [[ -f "colors.properties" ]]; then
  mv colors.properties ${TermDir};fi
  if [[ -f "font.ttf" ]]; then
  mv font.ttf ${TermDir};fi
  eval "termux-reload-settings";phase2;
}

dependencies(){
  if [[ $(cat ${lisence}) == *"zsh:True"* ]]; then
    echo;bl -s "Packages are already installed...";
  else echo;bl -s "Needed packages are installing...";
  echo -e "\e[0;2m\e[0;2m";apt install git zsh -y;
    if [[ ${?} == 1 ]]; then
    echo -e "${enc}";bl -a "Installation Failed...";return 1;
    else echo "zsh:True" >> "${TermDir}/${lisence}";echo -ne "${enc}";fi
  fi
}

starter(){
  echo;banner;
  if [[ -d "${HOME}/storage" ]]; then
  echo;bl -s "Internal storage permission is already permitted...";
  else echo;bl -s "Internal storage permission ask...";
  eval "termux-setup-storage";
  if [[ -d ${TermDir} ]]; then
  mkdir -p "${TermDir}";echo "Author:Harsh B" >> "${TermDir}/${lisence}";fi
  fi
  dependencies;
}