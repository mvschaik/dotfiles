#!/bin/sh

set -euf

CURDIR=$( cd "$(dirname "$0")" ; pwd -P )

if ! grep -q -s "path = $CURDIR/gitconfig" ~/.gitconfig; then
    cat >> ~/.gitconfig <<EOT
[include]
    path = $CURDIR/gitconfig
EOT
    echo "Infected .gitconfig"
fi

if [ ! -e ~/.vimrc ]; then
    ln -s $CURDIR/.vimrc ~/.vimrc
    mkdir -p ~/.vim/backup
    echo "Deployed .vimrc"
fi

if ! grep -q -s "source $CURDIR/tmux.conf" ~/.tmux.conf; then
    if [ ! -e ~/.tmux.conf ]; then
        touch ~/.tmux.conf
    fi
    echo "source $CURDIR/tmux.conf" > ~/.tmux.conf.tmp
    cat ~/.tmux.conf >> ~/.tmux.conf.tmp
    mv ~/.tmux.conf.tmp ~/.tmux.conf
    echo "Infected .tmux.conf"
fi

ZSH_PATH=$(command -v zsh)
if [ $ZSH_PATH ]; then
    echo "$ZSH_PATH found, configuring"
    if [ ! -e ~/.oh-my-zsh ]; then
        echo "Installing oh-my-zsh"
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    fi

    ZSH_PLUGINDIR=~/.oh-my-zsh/custom/plugins
    ZSH_PLUGINS="zsh-autosuggestions zsh-syntax-highlighting"

    for plugin in $ZSH_PLUGINS; do
        if [ ! -e $ZSH_PLUGINDIR/$plugin ]; then
            echo "Installing $plugin"
            git clone https://github.com/zsh-users/$plugin.git $ZSH_PLUGINDIR/$plugin
        fi
    done

    if [ ! -e ~/.oh-my-zsh/custom/themes/maarten.zsh-theme ]; then
        ln -s $CURDIR/maarten.zsh-theme ~/.oh-my-zsh/custom/themes/maarten.zsh-theme
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
