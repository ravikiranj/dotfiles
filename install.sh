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
cat ./bashrc_shortcuts >> $HOME/.bashrc
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
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    echo "Install tpm plugins via Ctrl+A + I"
}

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install vim tmux screen colordiff ack the_silver_searcher
    install_tpm
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install vim tmux screen colordiff ack-grep silversearcher-ag
    install_tpm
elif [ "$(uname)" == "Darwin" ]; then
    which brew
    if [ $? -eq "0" ]; then
        echo "brew is installed"
        brew install vim tmux screen colordiff ack the_silver_searcher
        install_tpm
    else
        echo "brew is not installed, please install brew by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Install below packages using your beloved package manager"
    echo "<PACKAGE_MANAGER> install vim tmux screen colordiff ack/ack-grep"
    echo "Run \"vim\" to configure plugins"
fi

echo "Your system setup is complete."
