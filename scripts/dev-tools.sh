if [[ $(which docker) ]]; then
    sudo apt-get remove docker docker-engine docker.io -y
    sudo apt-get purge docker-ce
fi

curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh

if [[ ! -d /usr/bin/toolbox ]]; then
    curl -fsSL https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.8.3678.tar.gz -o toolbox.tar

    tar -xvf toolbox.tar -C /usr/bin/toolbox 
fi