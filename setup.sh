function safe_install_packages {
    local args="$@"

    echo "packages to install: $args"
    if [[ $release == *"arch-release"* ]]; then
        cmd="sudo pacman -S $args --noconfirm"
    elif [[ $release == *"lsb-release"* ]]; then
        cmd="sudo apt-get install -y $args"
    fi

    echo "Executing command... $cmd"
    exec $cmd
}

function safe_install_script() {
    local archive_dir="archives"
    local filename=$(echo $1 | awk -F/ '{print $NF}')

    if [[ ! -d $archive_dir ]]; then
        mkdir $archive_dir
    fi

    if [[ ! -f "$archive_dir/$filename" ]]; then
        curl -k $1 -o "$archive_dir/$filename"
        chmod +x "$archive_dir/$filename"
        "./$archive_dir/$filename" $2
    fi
}

# sudo locale-gen "en_US.UTF-8"

release=$(ls /etc/*-release)
if [[ $release == *"arch-release"* ]]; then
    echo "provisioning for arch"
    sudo pacman -Syu --noconfirm
    echo "Installing packages..." 
    sudo pacman -S git jq curl gcc lightdm lightdm-gtk-greeter xfce4 --noconfirm
    sudo sed -i.bak 's/#greeter-session=/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
    sudo systemctl enable lightdm.service
    sudo systemctl restart lightdm
    
elif [[ $release == *"lsb-release"* ]]; then
    echo "provisioning for debian based distros"
    # sudo dpkg-reconfigure -f noninteractive locales
    # sudo dpkg-reconfigure -f noninteractive keyboard-configuration

    sudo apt-get update -y
    DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
    echo "Installing packages..." 
    sudo apt-get install -y git jq curl gcc
fi

echo "Downloading && executing scripts..."
if [[ ! -d "$HOME/miniconda" ]]; then 
    safe_install_script "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" "-b -p $HOME/miniconda"
fi

