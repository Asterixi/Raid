	      sudo apt-get update 
	      sudo apt-get -y upgrade
	      mkdir -p ~root/.ssh
              cp ~vagrant/.ssh/auth* ~root/.ssh
	      sudo apt-get install -y --force-yes mdadm smartmontools hdparm gdisk
	      sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sda /dev/sdb /dev/sdc
	      sudo fdisk /dev/md0
	      #for i in {1..5} do    Единственное, что честно списал с презентации-но не работает, выдает ошибку
	      #sudo sgdisk -n ${i}:0:+1G /dev/md0
	      #done
	      sudo sgdisk -n p:0:+1G /dev/md0
	      sudo sgdisk -n p:0:+1G /dev/md0
	      sudo sgdisk -n p:0:+2G /dev/md0
	      sudo sgdisk -n p:0:+1G /dev/md0
	      sudo sgdisk -n p:0:+2G /dev/md0
	      lsblk


