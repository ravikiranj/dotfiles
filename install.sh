#!/bin/bash

# Copy files
echo "Copying files"
cp ./vimrc ~/.vimrc
cp ./tmux.conf ~/.tmux.conf
cp ./screenrc ~/.screenrc
cp ./ackrc ~/.ackrc
cp ./vrapperrc ~/.vrapperrc
cp ./ideavimrc ~/.ideavimrc

echo "Done."
echo "Run 'vim' to configure plugins"
