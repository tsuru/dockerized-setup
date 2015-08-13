# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.provision "shell",
    inline: "wget -qO- https://get.docker.com/ | sh ; sudo usermod -aG docker vagrant"

  config.vm.define :default do |tsuru|
    tsuru.vm.hostname = 'tsuru'
    tsuru.vm.network "private_network", ip: "192.168.33.10"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

  end

end
