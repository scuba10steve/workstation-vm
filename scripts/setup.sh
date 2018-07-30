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
    sudo pacman -Rs virtualbox-guest-utils-nox --noconfirm
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch git base-devel jq curl lightdm lightdm-gtk-greeter xfce4 xfce4-goodies xorg-server chromium --noconfirm
    sudo sed -i.bak 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
    sudo sed -i.bak 's/logind-check-graphical=false/logind-check-graphical=true/' /etc/lightdm/lightdm.conf
    sudo sed -i.bak 's/#autologin-user=/autologin-user=vagrant/' /etc/lightdm/lightdm.conf
    sudo groupadd autologin
    sudo gpasswd -a vagrant autologin
    sudo systemctl enable lightdm.service
    sudo systemctl restart lightdm
    
elif [[ $release == *"lsb-release"* ]]; then
    echo "provisioning for debian based distros"
    # sudo dpkg-reconfigure -f noninteractive locales
    # sudo dpkg-reconfigure -f noninteractive keyboard-configuration

    sudo apt-get update -y
    DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
    echo "Installing packages..." 
    sudo apt-get install -y git jq curl gcc chromium build-essential
fi

echo "Downloading && executing scripts..."
if [[ ! -d "$HOME/miniconda" ]]; then 
    safe_install_script "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" "-b -p $HOME/miniconda"
fi