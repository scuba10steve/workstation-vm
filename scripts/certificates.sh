mkdir -p /home/vagrant/tmp
cp /vagrant/work-assets/certificates/*.cer /home/vagrant/tmp
pushd /home/vagrant/tmp
    rename .cer .crt *.cer
popd
release=$(ls /etc/*-release)
if [[ $release == *"arch-release"* ]]; then
    echo "provisioning for arch"
    sudo mv /home/vagrant/tmp/*.crt /etc/ca-certificates/trust-source/anchors/
    sudo trust extract-compat
elif [[ $release == *"lsb-release"* ]]; then
    echo "provisioning for debian/ubuntu"
    sudo mv /home/vagrant/tmp/*.crt /usr/local/share/ca-certificates/
    sudo update-ca-certificates
fi
