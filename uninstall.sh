#!/bin/sh

echo 'Uninstalling dotfiles...'
for F in $(ls .bashrc .hgrc .gitconfig .gemrc); do
	if [ -f $HOME/$F ]; then
		echo "Removing $F"
		rm $HOME/$F
	fi
done
echo 'Done'
