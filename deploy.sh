#!/bin/sh

CURDIR=$( cd "$(dirname "$0")" ; pwd -P )

if [ ! -e ~/.gitconfig ]; then
    if git version | grep "1.7" > /dev/null; then
        ln -s $CURDIR/.gitconfig.1.7 ~/.gitconfig
    else
        ln -s $CURDIR/.gitconfig.1.8 ~/.gitconfig
    fi
    echo "Deployed .gitconfig"
fi

if [ ! -e ~/.vimrc ]; then
    ln -s $CURDIR/.vimrc ~/.vimrc
    mkdir -p ~/.vim/backup
    echo "Deployed .vimrc"
fi

if [ ! -e ~/.screenrc ]; then
    ln -s $CURDIR/.screenrc ~/.screenrc
    echo "Deployed .screenrc"
fi

if ! grep -q dotfiles/.bashrc ~/.bashrc >/dev/null 2>&1; then
    echo "if [ -f ~/dotfiles/.bashrc ]; then . ~/dotfiles/.bashrc; fi" >> ~/.bashrc
    echo "Infected .bashrc"
fi
