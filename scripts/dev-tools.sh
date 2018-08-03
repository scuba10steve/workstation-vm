release=$(ls /etc/*-release)
if [[ $release == *"arch-release"* ]]; then
    if [[ ! $(which docker) ]]; then
        sudo pacman -S docker --noconfirm
        sudo systemctl enable docker.service

        sudo gpasswd -a vagrant docker
    else
        sudo pacman -Syu
    fi
elif [[ $release == *"lsb-release"* ]]; then
    if [[ $(which docker) ]]; then
        sudo apt-get remove docker docker-engine docker.io -y
        sudo apt-get purge docker-ce
    fi

    curl -fsSL get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi

TOOLBOX_VERSION="1.10.4088"

if [[ ! -d /usr/bin/toolbox ]]; then
    curl -fsSL https://download.jetbrains.com/toolbox/jetbrains-toolbox-$TOOLBOX_VERSION.tar.gz -o toolbox.tar

    sudo mkdir -p /usr/bin/toolbox
    sudo tar -xvf toolbox.tar -C /usr/bin/toolbox 
    sudo mv /usr/bin/toolbox/jetbrains-toolbox-$TOOLBOX_VERSION/* /usr/bin/toolbox/
    sudo chown -R vagrant:vagrant /usr/bin/toolbox/*
    sudo rm -f toolbox.tar
    sudo rm -rf usr/bin/toolbox/jetbrains-toolbox-$TOOLBOX_VERSION/
fi

if [[ ! -d /home/vagrant/.sdkman/ ]]; then  
    curl -s "https://get.sdkman.io" | bash
else
    source /home/vagrant/.sdkman/bin/sdkman-init.sh

    sdk selfupdate
fi