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

if [[ ! -d /usr/bin/toolbox ]]; then
    curl -fsSL https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.8.3678.tar.gz -o toolbox.tar

    sudo mkdir -p /usr/bin/toolbox
    sudo tar -xvf toolbox.tar -C /usr/bin/toolbox 
    sudo rm -f toolbox.tar
fi