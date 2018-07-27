Vagrant.configure('2') do |config|
  # Budgie desktop
  # config.vm.box = "pristine/ubuntu-budgie-18-x64"
  # Xubuntu desktop
  # config.vm.box = "acntech/xubuntu-developer"
  # Pure Ubuntu cli
  # config.vm.box = "generic/ubuntu1604"
  # Linux Mint
  # config.vm.box = "npalm/mint17-amd64-cinnamon"
  # arch
  config.vm.box = "archlinux/archlinux"

  config.vm.hostname = 'workstation-vm'
  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.memory = 8192
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--monitorcount", "3"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "85"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "hosttoguest"]
  end

  config.vm.provision "base_setup", type: "shell", path: "setup.sh", privileged: false
end
