#!/bin/bash

# Variables
Red="\e[0;31m"
Green="\e[0;32m"
Blue="\e[0;34m"
Alert="\e[0;31m[×]"
Success="\e[0;32m[+]"
dim="\e[0;2m"
enc="\e[0;m"

# Variables
config="$HOME/.configration"

echo -e "$dim
╦ ╦  ╔═╗  ╦═╗  ╔═╗  ╦ ╦
╠═╣  ╠═╣  ╠╦╝  ╚═╗  ╠═╣
╩ ╩  ╩ ╩  ╩╚═  ╚═╝  ╩ ╩
$enc"

phase2(){
    
    if [[ -f "$config/phase2.har" ]]; then
        #statements
        echo -e "$Success Phase2 Already Passed !$enc"
        echo ""
    else
        echo -e "$Success Initializing...Phase2$enc"
        echo -e "$dim$dim"
        {
            git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1
        }&&{
            if [[ -f "$HOME/.zshrc" ]]; then
                #statements
                mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
            fi
            cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
            sed -i '/^ZSH_THEME/d' "$HOME/.zshrc"
            sed -i '1iZSH_THEME="agnoster"' "$HOME/.zshrc"
            echo "alias chcolor='$HOME/.termux/colors.sh'" >> "$HOME/.zshrc"
            echo "alias chfont='$HOME/.termux/fonts.sh'" >> "$HOME/.zshrc"
        }&&{
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
        }&&{
            echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
        }&&{
            chsh -s zsh
        }&&{
            echo -e "$enc"
            chmod +x $HOME/.termux/colors.sh
            $HOME/.termux/colors.sh
            echo -e "$enc"
            chmod +x $HOME/.termux/fonts.sh
            $HOME/.termux/fonts.sh
        
            echo "True" >> "$config/phase2.har"
            echo ""
            echo -e "$Success Passed Phase2$enc"
            echo ""
            echo -e "$Success Setup Complete Successfully !$enc"
            echo ""
            echo -e "$Success Please restart Termux app..."
            echo ""
            cd
            rm -rf ../usr/etc/motd* &> /dev/null
            exit
        }
    fi
}

phase1(){
    
    if [[ -f "$config/phase1.har" ]]; then
        #statements
        echo -e "$Success Phase1 Already Passed !$enc"
        echo ""
        phase2
    else
        echo ""
        echo -e "$Success Initializing...Phase1$enc"
        echo -e "$dim$dim"
        if [[ -d "$HOME/.termux" ]]; then
            #statements
            mv "$HOME/.termux" "$HOME/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
        fi
            {
                curl -OL https://raw.githubusercontent.com/ytstrange/Docx/main/termux-style/termux.zip
            }&&{
                unzip -d $HOME termux.zip
            }&&{
                rm termux.zip
            }&&{
                echo "True" >> "$config/phase1.har"
                echo -e "$enc"
                echo -e "$Success Passed Phase1 $enc"
                echo ""
            }&&{
                phase2
            }
    fi
}

dependencies(){
    if [[ -f "$config/dependencies_installed.har" ]]; then
        #statements
        echo ""
        echo -e "$Success Dependencies Already Installed !$enc"
        echo ""
        phase1
    else
        echo ""
        echo -e "$Success Installing Dependencies...$enc"
        echo -e "$dim$dim"
        {
            apt-get install zsh git -y
        }&&{
            echo "True" >> "$config/dependencies_installed.har"
        }&& phase1
    fi
}

config_files(){
    if [[ -d "$config" ]]; then
        #statements
        dependencies
    else
        mkdir $config
        if [[ -d "$config" ]]; then
            #statements
            dependencies
        fi
    fi
}

storage_setup(){
    
    echo ""
    if [[ -d "$HOME/storage" ]]; then
        #statements
        echo -e "$Success Storage Setup Already Satisfied !$enc"
        config_files
    else
        echo -e "$Alert$Green Allow$Red Storage !$enc"
        termux-setup-storage && config_files
    fi
}

storage_setup
