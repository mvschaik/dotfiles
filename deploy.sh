#!/bin/sh

set -euf

CURDIR=$( cd "$(dirname "$0")" ; pwd -P )

if [ ! -e ~/.gitconfig ]; then
    ln -s $CURDIR/gitconfig ~/.gitconfig
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

ZSH_PATH=$(command -v zsh)
if [ $ZSH_PATH ]; then
    echo "$ZSH_PATH found, configuring"
    if [ ! -e ~/.oh-my-zsh ]; then
        echo "Installing oh-my-zsh"
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    fi

    if [ ! -e ~/.zshrc ]; then
        ln -s $CURDIR/zshrc ~/.zshrc
        echo "Deployed .zshrc"
    fi

    if [ $SHELL != $ZSH_PATH ]; then
        echo "Configuring zsh as current shell"
        chsh -s $ZSH_PATH
    fi
fi

if [ ! $ZSH_PATH ]; then
    if ! grep -q dotfiles/.bashrc ~/.bashrc >/dev/null 2>&1; then
        echo "if [ -f ~/dotfiles/.bashrc ]; then . ~/dotfiles/.bashrc; fi" >> ~/.bashrc
        echo "Infected .bashrc"
    fi
    if ! grep -q .bashrc.local ~/.bashrc >/dev/null 2>&1; then
        echo "if [ -f ~/.bashrc.local ]; then . ~/.bashrc.local; fi" >> ~/.bashrc
        echo "Including local bashrc"
    fi
fi
