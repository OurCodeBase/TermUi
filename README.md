# TermUi
TermUi is a tool 🔧 which can be used to automatically install themes 🖌️ zsh, and many more in
[Termux](https://github.com/termux/termux-app) and 
[UserLand](https://github.com/CypherpunkArmory/UserLAnd) Terminals.
You have to choose functions and the tool automate all tasks, and give you instructions about installed packages and errors.

## Badges
![Maintained](https://img.shields.io/badge/Maintained-Yes-teal?style=for-the-badge&logo=github)
![Termux](https://img.shields.io/badge/termux-seagreen?style=for-the-badge&logo=gnometerminal)
![UserLand](https://img.shields.io/badge/userland-seagreen?style=for-the-badge&logo=android)

## Authors
- [@OurCodeBase](https://www.github.com/OurCodeBase)

## Features
- Incredible 86 ColorSchemes 🌈
- Fantastic 21 Fonts
- Fabulous Shell [zsh](https://www.zsh.org) 
- zsh syntax highlighting
- Command Line [ohmyzsh](https://ohmyz.sh)
- completion zsh autocompletion

## Necessary

To run this project, you will need to satisfy the following points

- You should have a good internet connection
- Your terminal should work properly
- You have UserLAnd or Termux

## Installation

Well, You can [check this out](EASYBOOT.md) to instantly setup Termux.

Install TermUi with mannual method using commands below 👇
* ᴏɴʟʏ ꜰᴏʀ ᴛᴇʀᴍᴜx
```bash
yes | (apt update && apt upgrade && apt install wget) && wget "https://tinyurl.com/TermUi" && chmod 777 TermUi
```

* ᴏɴʟʏ ꜰᴏʀ ᴜꜱᴇʀʟᴀɴᴅ
```bash
yes | (sudo apt update && sudo apt install wget unzip) && wget "https://tinyurl.com/TermUi" && chmod 777 TermUi
```
## Usage
Execute the bash script using the command given below
```bash
bash TermUi
```


## Related

If you want compatible buttons ⌨️ for neovim for shortcut completions then the installation code is given below 👇
![Short](https://github.com/OurCodeBase/cooked.nvim/raw/main/images/vimcompatiblebuts.jpg)

```bash
wget -O "/data/data/com.termux/files/home/.termux/termux.properties" "raw.githubusercontent.com/OurCodeBase/cooked.nvim/main/termux.properties"
```
