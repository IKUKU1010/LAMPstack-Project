# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  
  ### Master vm  ####
  config.vm.define "Master_N" do |master_n|
    master_n.vm.box = "ubuntu/focal64"
    master_n.vm.hostname = "MasterNode"
    master_n.vm.network "private_network", ip: "192.168.33.23"
    master_n.vm.provider "virtualbox" do |vb|
    end
  end
  
  ### Slave Node vm  #### 
  config.vm.define "Slave_N" do |slave_n|
    slave_n.vm.box = "ubuntu/focal64"
    slave_n.vm.hostname = "SlaveNode"
    slave_n.vm.network "private_network", ip: "192.168.32.22"
    slave_n.vm.provider "virtualbox" do |vb|
    end
  end
  
end
