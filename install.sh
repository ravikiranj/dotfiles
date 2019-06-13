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

if grep -v '# Custom Aliases added by ravikiranj dotfiles' $HOME/.bashrc > /dev/null; then
    cat ./bashrc_shortcuts >> $HOME/.bashrc
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

function add_shortcuts_to_zshrc() {
    if grep -v '# Custom Aliases added by ravikiranj dotfiles' $HOME/.zshrc > /dev/null; then
        cat ./zshrc_shortcuts >> $HOME/.zshrc
    fi
}

function install_ohmyzsh() {
    echo "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"

    echo "Installing powerlevel9k theme for zsh"
    git clone https://github.com/bhilburn/powerlevel9k.git $HOME/.oh-my-zsh/custom/themes/powerlevel9k

    echo "Changing theme to powerlevel9k"

    if [ -f $HOME/.zshrc ]; then
        sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/' $HOME/.zshrc
    fi

    add_shortcuts_to_zshrc
}

function install_powerline_fonts() {
    pushd /tmp

    # clone
    git clone https://github.com/powerline/fonts.git --depth=1

    # install
    cd fonts
    ./install.sh

    popd
}

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install git vim tmux screen colordiff ack the_silver_searcher curl zsh ripgrep
    install_tpm
    install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
    install_powerline_fonts
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo apt-get update && sudo $PACKAGE_MANAGER install -y git vim tmux screen colordiff ack-grep silversearcher-ag curl zsh ripgrep
    install_tpm
    install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
    install_powerline_fonts
elif [ "$(uname)" == "Darwin" ]; then
    which brew
    if [ $? -eq "0" ]; then
        echo "brew is installed"
        brew install git vim tmux screen colordiff ack the_silver_searcher curl zsh ripgrep
        install_tpm
        install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
        install_powerline_fonts
    else
        echo "brew is not installed, please install brew by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Your operating system is not supported for installing packages, sorry!"
    exit 1
fi

echo "Your system dotfiles setup is complete."
echo "You should now change your default shell to zsh (chsh) and install tpm plugins (Ctrl+A + I)."
