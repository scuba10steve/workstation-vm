if [[ ! -d /home/vagrant/aur/ ]]; then
    mkdir -p /home/vagrant/aur
fi

pushd /home/vagrant/aur

    for repo in $(cat /vagrant/scripts/arch/repos.txt); do

        dirname=$(echo $(echo $repo | sed 's/https:\/\/aur.archlinux.org\///') | sed 's/.git//')

        if [[ ! -d $dirname ]]; then
            git clone $repo
        fi

        pushd $dirname
        git pull
        if [[ ! $(makepkg -si --noconfirm) ]]; then
            popd
        else
            popd
        fi
    done
popd
