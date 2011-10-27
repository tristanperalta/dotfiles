#!/bin/sh

echo 'Installing dotfiles...'
for F in $(ls .bashrc .hgrc .gitconfig .gemrc); do
	if [ -f $HOME/$F ]; then
		echo "**** Found existing ${F}, skipping..."
	else
		echo "Symlinking ${F}"
		ln -s $PWD/$F $HOME/$F
	fi
done
echo 'Done'
