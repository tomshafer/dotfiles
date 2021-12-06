
if [[ -f ~/.bash_profile ]]; then
    cat bash/bash_profile >> ~/.bash_profile
else
    ln -sf bash/bash_profile ~/.bash_profile
fi

if [[ -f ~/.bashrc ]]; then
    cat bash/bashrc >> ~/.bashrc
else
    ln -sf bash/bashrc ~/.bashrc
fi

if [[ -f ~/.bashrc ]]; then
    cat bash/inputrc >> ~/.inputrc
else
    ln -sf bash/inputrc ~/.bashrc
fi

if [[ -f ~/.gitconfig ]]; then
    cat git/gitconfig >> ~/.gitconfig
else
    cp git/gitconfig ~/.gitconfig
fi
