#!/bin/bash

set -e

# Copy files
echo "Copying files and shortcuts"
cp ./vimrc ~/.vimrc
cp ./tmux.conf ~/.tmux.conf
cp ./screenrc ~/.screenrc
cp ./ackrc ~/.ackrc
cp ./vrapperrc ~/.vrapperrc
cp ./ideavimrc ~/.ideavimrc
cat ./bashrc_shortcuts >> ~/.bashrc
echo "Done."

# Post install notes
PACKAGE_MANAGER=""
if [ -f /etc/redhat-release  ]; then
    PACKAGE_MANAGER="yum"
fi

if [ -f /etc/lsb-release  ]; then
    PACKAGE_MANAGER="apt-get"
fi

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install vim tmux screen colordiff ack the_silver_searcher
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER install vim tmux screen colordiff ack-grep silversearcher-ag
elif [[ "$OSTYPE" =~ ^darwin.+ ]]; then
    which brew
    if [ $? -eq "0" ]; then
        echo "brew is installed"
        brew install vim tmux screen colordiff ack the_silver_searcher
    else
        echo "brew is not installed, please install brew by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Install below packages using your beloved package manager"
    echo "<PACKAGE_MANAGER> install vim tmux screen colordiff ack/ack-grep"
    echo "Run \"vim\" to configure plugins"
fi

echo "Your system setup is complete."
