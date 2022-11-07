# -*- mode: ruby -*-
# vim: set ft=ruby :
require 'fileutils'

VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

# Директория для хранения дисков
VAGRANT_DISKS_DIRECTORY = "disks"

# размещение контроллера
VAGRANT_CONTROLLER_NAME = "Virtual I/O Device SCSI controller"
VAGRANT_CONTROLLER_TYPE = "virtio-scsi"

# создание дисков по 5 гб, sda,sdb,sdc, сборка рейда произойдёт в скрипте provision.sh
local_disks = [
  { :filename => "disk1", :size => 5, :port => 5 },
  { :filename => "disk2", :size => 5, :port => 6 },
  { :filename => "disk3", :size => 5, :port => 7 }
]

Vagrant.configure("2") do |config| 
  config.vm.box = "bento/ubuntu-20.04"
  
  config.vm.provider "virtualbox" do |vb|

    vb.name = "Ubunta"
    vb.memory = "2048"
    vb.cpus = 1
  end 
  
  disks_directory = File.join(VAGRANT_ROOT, VAGRANT_DISKS_DIRECTORY)

  # Создание дисков перед "vagrant up" 
  config.trigger.before :up do |trigger|
    trigger.name = "Create disks"
    trigger.ruby do
      unless File.directory?(disks_directory)
        FileUtils.mkdir_p(disks_directory)
      end
      local_disks.each do |local_disk|
        local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
        unless File.exist?(local_disk_filename)
          puts "Creating \"#{local_disk[:filename]}\" disk"
          system("vboxmanage createmedium --filename #{local_disk_filename} --size #{local_disk[:size] * 1024} --format VDI")
        end
      end
    end
  end

  # Создание хранилища при первой загрузке
  unless File.directory?(disks_directory)
    config.vm.provider "virtualbox" do |storage_provider|
      storage_provider.customize ["storagectl", :id, "--name", VAGRANT_CONTROLLER_NAME, "--add", VAGRANT_CONTROLLER_TYPE, '--hostiocache', 'off']
    end
  end

  # Подключение устройств хранения
  config.vm.provider "virtualbox" do |storage_provider|
    local_disks.each do |local_disk|
      local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
      unless File.exist?(local_disk_filename)
        storage_provider.customize ['storageattach', :id, '--storagectl', VAGRANT_CONTROLLER_NAME, '--port', local_disk[:port], '--device', 0, '--type', 'hdd', '--medium', local_disk_filename]
      end
    end
  end

  # очистка после удаления VM
  config.trigger.after :destroy do |trigger|
    trigger.name = "Cleanup operation"
    trigger.ruby do
      # Удаление 
      local_disks.each do |local_disk|
        local_disk_filename = File.join(disks_directory, "#{local_disk[:filename]}.vdi")
        if File.exist?(local_disk_filename)
          puts "Deleting \"#{local_disk[:filename]}\" disk"
          system("vboxmanage closemedium disk #{local_disk_filename} --delete")
        end
      end
      if File.exist?(disks_directory)
        FileUtils.rmdir(disks_directory)
      end
    end
  end
  config.vm.hostname = "Ubunta" 
  
  config.vm.provision "shell", path: "provision.sh"
end


