# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.provision "shell",
    inline: "wget -qO- https://get.docker.com/ | sh ; sudo usermod -aG docker vagrant"
  # Allow Mac OS X docker client to connect to Docker without TLS auth
  # config.vm.provision "shell",
    # inline: "sudo bash -c \'echo \"DOCKER_TLS=no\" > /etc/default/docker\'"
  # config.vm.provision "shell",
    # inline: "sudo bash -c \'echo \"DOCKER_OPTS=\'"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -r --insecure-registry registry.service.consul:5000"\'\" >> /etc/default/docker\'"
  # config.vm.provision "shell",
  #   inline: "sudo stop docker && sudo start docker"

  config.vm.define :default do |tsuru|
    tsuru.vm.hostname = 'tsuru'
    tsuru.vm.network "private_network", ip: "192.168.33.10"

    tsuru.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "4"]
    end

  end

end
