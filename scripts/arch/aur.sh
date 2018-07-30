if [[ ! -d $HOME/aur/ ]]; then
    sudo mkdir -p $HOME/aur
fi

pushd $HOME/aur

    if [[ ! -d $HOME/aur/phoronix-test-suite/ ]]; then
        git clone https://aur.archlinux.org/phoronix-test-suite.git
    fi

    pushd phoronix-test-suite
        makepkg -si
    popd phoronix-test-suite

popd $HOME/aur