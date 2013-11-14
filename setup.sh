#!/bin/bash

sudo apt-get install vim-gtk clang exuberant-ctags git python-fontforge unzip mercurial libclang-dev nodejs npm cmake

git submodule update --init
git submodule foreach git checkout master

for file in `ls -A -I .git -I .gitmodules -I setup.sh -I .kde`;
do
	echo $PWD/$file

	if [ $PWD/$file == `readlink -f $HOME/$file` ]; then
		echo "skipping..."
		continue
	elif [ -e $HOME/$file ]; then
		echo "backuping..."
		mv $HOME/$file $HOME/$file-backup-`date +%Y%m%d%H%M%S`
		echo "replacing..."
	else
		echo "linking..."
	fi

	ln -sf $PWD/$file $HOME
done

vim +NeoBundleInstall +q

ls $HOME/.fonts/Ubuntu*-Powerline.ttf > /dev/null

if [ $? -ne 0  ]; then

	mkdir -p ~/tmp
	wget -c http://font.ubuntu.com/download/ubuntu-font-family-0.80.zip -O ~/tmp/ubuntu-font-family-0.80.zip

	unzip ~/tmp/ubuntu-font-family-0.80.zip -d ~/tmp

	pushd ~/tmp/ubuntu-font-family-0.80

	chmod +x ~/.vim/bundle/vim-powerline_develop/fontpatcher/fontpatcher

	for f in `ls *.ttf`;
	do
		~/.vim/bundle/vim-powerline_develop/fontpatcher/fontpatcher $f
	done

	fonts=`ls *Powerline.ttf`

	if [ $? -eq 0 ]; then
		mkdir -p $HOME/.fonts
		cp $fonts $HOME/.fonts
		sudo fc-cache -vf
	fi

	popd

	rm -rf ~/tmp
fi

