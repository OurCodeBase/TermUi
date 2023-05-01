# Introduction
Well, If want to install or setup [Termux](https://github.com/termux/termux-app)
instantly you can check this out. This command will setup your [Termux](https://github.com/termux/termux-app)
in one touch. Only you have to do that copy the given command and paste it into your [Termux](https://github.com/termux/termux-app)
Terminal.

## Features
- Fabulous Shell [zsh](https://www.zsh.org) 
- zsh syntax highlighting
- Command Line [ohmyzsh](https://ohmyz.sh)

## Installation
- Make sure that you have you have a Working Termux.
- This command is incompatible with UserLand.
```bash
yes | (apt update && apt upgrade && apt install wget) && bash -c "$(wget raw.githubusercontent.com/OurCodeBase/TermUi/main/assets/boot.sh -O -)"
```
