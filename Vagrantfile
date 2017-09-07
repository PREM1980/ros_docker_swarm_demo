# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
robot = {
  "nav" => { :ip => "192.168.33.101", :mem => 1024 },
  "img" => { :ip => "192.168.33.102", :mem => 1024 },
  "ops" => { :ip => "192.168.33.103", :mem => 1024 },
}
Vagrant.configure("2") do |config|
  robot.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |config|
      #########################################
      #
      # Some plugins to help speed things up.
      # These are all optional.
      #
      #########################################

      # Share apt cache
      if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.synced_folder_opts = { 
            type: :nfs,
            mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
        }
        config.cache.scope = :box
        config.cache.auto_detect = true
      end

      # Manage vbguest update
      if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
        config.vbguest.no_remote = true
      end
      
      #########################################
      #
      # Real stuff starts here,
      #
      #########################################
      if hostname == "ops"
        config.vm.box = "ubuntu/trusty64"
      else
        config.vm.box = "debian/stretch64"
      end
      config.vm.box_check_update = false
      config.vm.network "private_network", ip: info[:ip]
      config.vm.hostname = hostname
      config.vm.provider :virtualbox do |vb|
        vb.memory = info[:mem]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # enable promiscuous mode on the private network (for macvlan driver)
        vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      end

      config.vm.synced_folder "shared", "/data/shared", id: "data", :nfs => true, :mount_options => ['nolock,vers=3,udp']

      # provision nodes with ansible
      if index == robot.size - 1
        config.vm.provision :ansible do |ansible|
          #ansible.verbose = "vvvv"
       	  ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
	  ansible.playbook = "provisioning/playbook.yml"
          ansible.limit = "all"
          ansible.groups = {
            "docker_swarm_manager" => ["nav"],
            "docker_swarm_worker"  => ["img"],
            "operations"           => ["ops"],
            "docker:children"      => ["docker_swarm_manager", "docker_swarm_worker"],
            "all_groups:children"  => ["docker", "operations"],
            "docker:vars"          => {
              "docker_swarm_network_config_name" => "rosdemo-config",
              "docker_swarm_network_name"        => "rosdemo",
              "docker_swarm_stack_name"          => "rosdemo",
              #              "docker_swarm_network_driver"      => "macvlan",
              "docker_swarm_network"             => "10.2.0.0/24"
            }
          }
          ansible.host_vars = {
            "nav" => { "swarm_labels" => "navigation" },
            "img" => { "swarm_labels" => "imaging" }
          }
        end # end provision
      end
    end
  end
end
