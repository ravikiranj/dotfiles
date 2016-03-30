#!/bin/bash

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
echo "Install below packages using your beloved package manager"
echo "<pkg_manager> install vim tmux screen colordiff ack/ack-grep"
echo "Run \"vim\" to configure plugins"
