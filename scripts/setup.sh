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
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch git base-devel jq curl lightdm lightdm-gtk-greeter xfce4 xfce4-goodies xorg-server chromium unzip zip p7zip papirus-icon-theme netdata --noconfirm
    sudo pacman -S numix-gtk-theme arc-gtk-theme --noconfirm
    sudo sed -i.bak 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
    sudo sed -i.bak 's/logind-check-graphical=false/logind-check-graphical=true/' /etc/lightdm/lightdm.conf
    sudo sed -i.bak 's/#autologin-user=/autologin-user=vagrant/' /etc/lightdm/lightdm.conf
    sudo sed -i.bak 's/#DefaultLimitNOFILE=/DefaultLimitNOFILE=20000/' /etc/systemd/user.conf
    sudo sed -i.bak 's/#DefaultLimitNOFILE=/DefaultLimitNOFILE=20000/' /etc/systemd/system.conf
    sudo sed -i 's/Adwaita/Numix/' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
    sudo cp /vagrant/assets/xfwm4.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
    sudo sed -i 's/gnome/ePapirus/' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
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
if [[ ! -d "/home/vagrant/miniconda" ]]; then 
    safe_install_script "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" "-b -p /home/vagrant/miniconda"
fi

mkdir -p /home/vagrant/git/{work,playground,tmp}