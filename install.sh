#!/bin/bash

# Fail script on errors
set -Eeuxo pipefail

trap "echo Encountered failure when running install.sh script!" ERR

# Identify package manager
PACKAGE_MANAGER=""
if [ -f /etc/redhat-release  ]; then
    PACKAGE_MANAGER="yum"
fi

if [ -f /etc/lsb-release  ]; then
    PACKAGE_MANAGER="apt-get"
fi

function copy_config_files() {
    echo "Started copying config files"
    cp ./vimrc "$HOME/.vimrc"
    cp ./tmux.conf "$HOME/.tmux.conf"
    cp ./screenrc "$HOME/.screenrc"
    cp ./ackrc "$HOME/.ackrc"
    cp ./vrapperrc "$HOME/.vrapperrc"
    cp ./ideavimrc "$HOME/.ideavimrc"
    echo "Completed copying config files"
}

function install_tpm() {
    echo "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "Install tpm plugins via Ctrl+A + I"
}

function add_shortcuts_to_bashrc() {
    echo "Adding shortcuts to bashrc"
    if grep -v '# Custom Aliases added by ravikiranj dotfiles' "$HOME/.bashrc" > /dev/null; then
        cat ./bashrc_shortcuts >> "$HOME/.bashrc"
    fi
}

function add_shortcuts_to_zshrc() {
    echo "Adding shortcuts to zshrc"
    ZSHRC_CONFIG="$HOME/.zshrc"
    if [ ! -f "${ZSHRC_CONFIG}" ]; then
        touch "${ZSHRC_CONFIG}"
    fi
    if grep -v '# Custom Aliases added by ravikiranj dotfiles' "${ZSHRC_CONFIG}" > /dev/null; then
        cat ./zshrc_shortcuts >> "${ZSHRC_CONFIG}"
    fi
}

function install_powerlevel10k() {
    echo "Installing powerlevel10k theme for zsh"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    echo "Changing theme to powerlevel10k"

    if [ -f "$HOME/.zshrc" ]; then
        sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
    fi

    echo "Copying p10k configuration"
    cp ./p10k.zsh "$HOME/.p10k.zsh"
}

function install_ohmyzsh() {
    echo "Installing ohmyzsh"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

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

function install_nerd_fonts() {
    ./install_nerd_fonts.sh
}

# Start Installation
copy_config_files
add_shortcuts_to_bashrc

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install git vim tmux screen colordiff ack the_silver_searcher curl zsh ripgrep wget
    install_tpm
    install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
    install_powerline_fonts
    install_nerd_fonts
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo apt-get update && sudo $PACKAGE_MANAGER install -y git vim tmux screen colordiff ack-grep silversearcher-ag curl zsh ripgrep wget
    sudo apt-get update
    install_tpm
    install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
    install_powerline_fonts
    install_nerd_fonts
elif [ "$(uname)" == "Darwin" ]; then
    if which brew; then
        echo "brew is installed"
        brew install git vim tmux screen colordiff ack the_silver_searcher curl zsh ripgrep wget
        install_tpm
        install_ohmyzsh || echo "ohmyzsh setup might have failed, please check!"
        install_powerline_fonts
        install_nerd_fonts
    else
        echo "brew is not installed, please install brew by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Your operating system is not supported for installing packages, sorry!"
    exit 1
fi

echo "Your system dotfiles setup is complete."
echo "You should now do the following steps to complete the installations"
echo "1. Change your default shell to zsh via 'chsh -s $(which zsh)'"
echo "2. Change terminal font to Meslo nerd Font"
echo "3. Configure powerlevel 10k via 'p10k configure'"
echo "4. Install tmux tpm plugins (Ctrl+A + I)"
# End Installation
