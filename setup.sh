#!/bin/bash

sudo apt-get install vim-gtk clang exuberant-ctags git python-fontforge unzip mercurial libclang-dev nodejs npm cmake python-dev python-git python-psutil cppcheck

git submodule update --init
git submodule foreach git checkout master

pushd .powerline
git checkout develop
popd
git submodule foreach git pull --rebase

for file in `ls -A -I .git -I .gitmodules -I setup.sh -I .kde -I screen-256color.terminfo`;
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

pushd .vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.sh --clang-completer
popd

if [[ -x `which tic` ]]; then
	mkdir -p $HOME/.terminfo
	tic ./screen-256color.terminfo
fi

ls $HOME/.fonts/Ubuntu*-Powerline*.ttf > /dev/null

if [ $? -ne 0  ]; then

	mkdir -p ~/tmp
	wget -c http://font.ubuntu.com/download/ubuntu-font-family-0.80.zip -O ~/tmp/ubuntu-font-family-0.80.zip

	unzip ~/tmp/ubuntu-font-family-0.80.zip -d ~/tmp

	pushd ~/tmp/ubuntu-font-family-0.80

	chmod +x ~/.powerline-fontpatcher/scripts/powerline-fontpatcher

	for f in *.ttf;
	do
		~/.powerline-fontpatcher/scripts/powerline-fontpatcher $f
	done

	fonts=`ls *Powerline*.ttf`

	if [ $? -eq 0 ]; then
		mkdir -p $HOME/.fonts
		for f in *Powerline*.ttf; do
			cp "$f" $HOME/.fonts
		done
		sudo fc-cache -vf
	fi

	popd

	rm -rf ~/tmp
fi

