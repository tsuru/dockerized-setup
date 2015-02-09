# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.define :default do |tsuru|
    tsuru.vm.hostname = 'tsuru'
    tsuru.vm.network "private_network", ip: "192.168.33.10"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--name", "tsuru"]
    end
  end

  config.vm.define :api_node1 do |tsuru|
    tsuru.vm.hostname = 'tsuru-api-node1'
    tsuru.vm.network "private_network", ip: "192.168.33.11"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--name", "tsuru-api-node1"]
    end
  end

  config.vm.define :api_node2 do |tsuru|
    tsuru.vm.hostname = 'tsuru-api-node2'
    tsuru.vm.network "private_network", ip: "192.168.33.12"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--name", "tsuru-api-node2"]
    end
  end

  config.vm.define :api_node3 do |tsuru|
    tsuru.vm.hostname = 'tsuru-api-node3'
    tsuru.vm.network "private_network", ip: "192.168.33.13"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--name", "tsuru-api-node3"]
    end
  end

end