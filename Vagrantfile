Vagrant.configure('2') do |config|
  # Budgie desktop
  # config.vm.box = "pristine/ubuntu-budgie-18-x64"
  # Xubuntu desktop
  # config.vm.box = "acntech/xubuntu-developer"
  # Ubuntu Server
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
    # vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "hosttoguest"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
  end

  config.vm.provision "base_setup", type: "shell", path: "scripts/setup.sh", privileged: true
  config.vm.provision "dev_tools", type: "shell", path: "scripts/dev-tools.sh", privileged: true
  config.vm.provision "cleanup", type: "shell", path: "scripts/cleanup.sh", privileged: false
end
