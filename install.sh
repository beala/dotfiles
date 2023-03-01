#!/bin/bash

function link-dotfile {
    if [ ! -e "$1" ]; then
        ln -s "$HOME/dotfiles/$1" "$1"
        echo "Created symlink for $1"
    else
        echo "File $1 already exists, skipping symlink creation"
    fi
}

cd || exit
echo "source $HOME/dotfiles/.bash_custom" >> ~/.zshrc

link-dotfile .gitconfig
link-dotfile .screenrc