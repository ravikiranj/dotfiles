#!/bin/bash

set -e

# Copy files
echo "Copying files and shortcuts"
cp ./vimrc $HOME/.vimrc
cp ./tmux.conf $HOME/.tmux.conf
cp ./screenrc $HOME/.screenrc
cp ./ackrc $HOME/.ackrc
cp ./vrapperrc $HOME/.vrapperrc
cp ./ideavimrc $HOME/.ideavimrc

if grep -v '# Custom Aliases added by ravikiranj dotfiles' ~/.bashrc > /dev/null; then
    cat ./bashrc_shortcuts >> $HOME/.bashrc
fi

if grep -v '# Custom Aliases added by ravikiranj dotfiles' ~/.zshrc > /dev/null; then
    cat ./zshrc_shortcuts >> $HOME/.zshrc
fi
echo "Done."

# Post install notes
PACKAGE_MANAGER=""
if [ -f /etc/redhat-release  ]; then
    PACKAGE_MANAGER="yum"
fi

if [ -f /etc/lsb-release  ]; then
    PACKAGE_MANAGER="apt-get"
fi

function install_tpm() {
    echo "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    echo "Install tpm plugins via Ctrl+A + I"
}

function install_ohmyzsh() {
    echo "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    echo "Installing powerlevel9k theme for zsh"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

    echo "Changing theme to powerlevel9k"

    if [ -f $HOME/.zshrc ]; then
        sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/' $HOME/.zshrc
    fi
}

function install_powerline_fonts() {
    pushd tmp

    # clone
    git clone https://github.com/powerline/fonts.git --depth=1

    # install
    cd fonts
    ./install.sh

    popd
}

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install git vim tmux screen colordiff ack the_silver_searcher curl zsh
    install_tpm
    install_ohmyzsh
    install_powerline_fonts
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo apt-get update && sudo $PACKAGE_MANAGER install -y git vim tmux screen colordiff ack-grep silversearcher-ag fonts-powerline curl zsh
    install_tpm
    install_ohmyzsh
elif [ "$(uname)" == "Darwin" ]; then
    which brew
    if [ $? -eq "0" ]; then
        echo "brew is installed"
        brew install git vim tmux screen colordiff ack the_silver_searcher curl zsh
        install_tpm
        install_ohmyzsh
        install_powerline_fonts
    else
        echo "brew is not installed, please install brew by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Your operating system is not supported for installing packages, sorry!"
    exit 1
fi

echo "Your system setup is complete. Press any key to exit"
read value
