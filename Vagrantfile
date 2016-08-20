# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  
  config.vm.network "forwarded_port", guest: 5432, host: 5433
  config.vm.network "forwarded_port", guest: 9990, host: 9990
  config.vm.network "forwarded_port", guest: 8080, host: 8081

  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.memory = "2048"
  end
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "vagrant.yml"
  end
end
