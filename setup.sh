function safe_install_package() {
    if [[ ! $(which $1) ]]; then
        sudo apt-get install -y $1
    fi
}

function safe_install_packages {
    local args=$@
    local packages
    for package in $args;
    do
        if [[ ! $(which $package) ]]; then
            packages+=("$package")
        fi
    done

    cmd="sudo apt-get install -y $packages"
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

sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure -f noninteractive locales
sudo dpkg-reconfigure -f noninteractive keyboard-configuration

sudo apt-get update -y
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

echo "Installing packages..."
safe_install_packages git jq curl
# safe_install_package jq
# safe_install_package curl

echo "Downloading && executing scripts..."
if [[ ! -d "$HOME/miniconda" ]]; then 
    safe_install_script "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" "-b -p $HOME/miniconda"
fi

