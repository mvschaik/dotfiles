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

include_in_file() {
    local filename="$1"
    local string="$2"

    if ! grep -q -s "$string" "$filename"; then
        mkdir -p ~/.vim/backup
        if [ ! -e "$filename" ]; then
            touch "$filename"
        fi
        echo "$string" > "$filename.tmp"
        cat "$filename" >> "$filename.tmp"
        mv "$filename.tmp" "$filename"
        echo "Infected $filename"
    fi
}

mkdir -p ~/.vim/backup
include_in_file ~/.vimrc "source $CURDIR/vimrc"

include_in_file ~/.tmux.conf "source $CURDIR/tmux.conf"

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
        cat > ~/.zshrc << EOF
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="maarten"
plugins=(git $ZSH_PLUGINS)
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
# Put custom aliases and stuff in \$ZSH_CUSTOM!
EOF
        echo "Deployed .zshrc"
    fi

    if ! grep -q -s DEFAULT_USER ~/.zshenv; then
        echo "DEFAULT_USER=$USER" >> ~/.zshenv
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
