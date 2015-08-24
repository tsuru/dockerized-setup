# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  # config.vm.provision "shell",
  #   inline: "wget -qO- https://get.docker.com/ | sh ; sudo usermod -aG docker vagrant"
  # Allow Mac OS X docker client to connect to Docker without TLS auth
  config.vm.provision "shell",
    inline: "sudo bash -c \'echo \"DOCKER_TLS=no\" > /etc/default/docker\'"
  config.vm.provision "shell",
    inline: "sudo bash -c \"echo DOCKER_OPTS='\\\"--dns 172.17.42.1 --dns 8.8.8.8 --dns-search=service.consul -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -r --insecure-registry registry.service.consul:5000\\\"' >> /etc/default/docker\""
  config.vm.provision "shell",
    inline: "sudo bash -c \"stop docker && sudo start docker\""

  config.vm.define :tsuru do |tsuru|
    tsuru.vm.hostname = 'tsuru'
    tsuru.vm.network "private_network", ip: "192.168.33.10"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "4"]
    end
  end

  config.vm.define :dockerNode do |node|
    node.vm.hostname = 'dockerNode'
    node.vm.network "private_network", ip: "192.168.33.11"

    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end


end
