#!/bin/sh

echo 'Installing dotfiles...'
DOTFILES_PATH=~/dotfiles/
ln -s ${DOTFILES_PATH}.bashrc     ~/.bashrc
ln -s ${DOTFILES_PATH}.hgrc       ~/.hgrc
ln -s ${DOTFILES_PATH}.gitconfig  ~/.gitconfig
ln -s ${DOTFILES_PATH}.gemrc      ~/.gemrc
echo 'Done'
