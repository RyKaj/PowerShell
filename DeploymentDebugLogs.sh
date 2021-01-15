########################################################################################################################################################
#
#.SYNOPSIS
#	Octopus Template process
#
#.DESCRIPTION
#	Scripts for deployment
#
#.SOURCECODELOCATION
#	
#	
#.USEAGE
#  
# 		
#.NOTE
#	Need to set permssions to file before you can execute in Jenkins
#		cd /var/lib/jenkins
#		
#		sudo chmod +x ./DeploymentDebugLogs.sh
#		./DeploymentDebugLogs.sh	
#
#	
#	Jenkins - FreeStyle
#		#!/bin/bash -xe
#		/var/lib/jenkins/DeploymentDebugLogs.sh
#		
#	Jenkins - Pipeline 
#		   stages {
#			  stage('System Information') {
#				 steps {
#						sh '''!/bin/bash
#							'/var/lib/jenkins/DeploymentDebugLogs.sh'
#						'''
#				 }
#			  }
#		   }
#	
#	
#
#.References
#   https://opensource.com/article/19/9/linux-commands-hardware-information
#	https://www.binarytides.com/linux-lshw-command/
#	https://www.howtogeek.com/456943/how-to-use-the-free-command-on-linux/
#	https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units
#
#
#
#
#
#.HISTORY
#
#######################################################################################################################################################>

echo "--------------------- Predeployment Start ---------------------------";

	############################################################################
	#  Linux server information
	#    NOTE: 
	#	Any Changes in this section MUST be reflected in "ITDev MySQL - 1 PreDeploy.txt"
	#   Any Changes in this section MUST be reflected in "Haywire - 1. PreDeploy.txt"
	############################################################################
	echo "--------------------- System Information - Start ------------------------------";

	echo " ";
	echo "--------------------- Linux current kernal version ------------------------------";
	uname -mrs;

	echo " ";
	echo "--------------------- Linux BIOS date and version  ------------------------------";
	dmidecode -t bios;
	
	echo " ";
	echo "--------------------- Linux cpu model Information ------------------------------";
	lshw -C cpu | grep -i product;
	
	echo " ";
	echo "--------------------- Linux cpu/hardware Information ------------------------------";
	lscpu;

	echo " ";
	echo "---------------------  Linux distribution and version ------------------------------";
	lsb_release -a 2> /dev/null;

	echo " ";
	echo "--------------------- Linux Memory ------------------------------";
	free -m;

	#echo " ";
	#echo "--------------------- Linux Top Process ------------------------------";
	##top -n 1;
	#echo [PID]  [MEM]  [PATH] &&  ps aux | awk '{print $2, $4, $11}' | sort -k2rn | head -n 20 2> /dev/null;

	#echo " ";
	#echo "--------------------- Linux Memory Usage ------------------------------";
	#ps -eo pcpu,pid,user,args | sort -k 1 -r | head -20 2> /dev/null;

	
	echo " ";
	echo "--------------------- Linux List all PCI devices ------------------------------";
	## a utility for displaying information about PCI buses in the system and devices connected to them.
	lspci;

	echo " ";
	echo "--------------------- Linux Detailed hardware configuration ------------------------------";
	## a small tool to extract detailed information on the hardware configuration of the machine. 
	## It can report exact memory configuration, firmware version, mainboard configuration, CPU version and speed, cache configuration, bus speed.
	lshw;
	
	echo " ";
	echo "--------------------- Linux List all USB devices ------------------------------";
	lsusb;

	echo " ";
	echo "--------------------- Linux List each disk device ------------------------------";
	lshw -short -C disk;
	
	echo " ";
	echo "--------------------- Linux Disk device (number of sectors, size, filesystem ID and type) ------------------------------";
	fdisk -l;
	
	echo " ";
	echo "--------------------- Linux List all block devices (hard disks, cdrom, and others) ------------------------------";
	lsblk;

	echo " ";
	echo "--------------------- Linux Network Interface Information ------------------------------";
	ifconfig -a;
	ip link show;
	netstat -i;
	
	echo " ";
	echo "--------------------- Linux Default Gateway Information  ------------------------------";
	ip route | column -t;
	netstat -r;

	echo " ";
	echo "--------------------- Print Envionrmnet Variables   ------------------------------";
	printenv

	echo " ";
	echo "--------------------- Installed version of .NET Core ------------------------------";
	dotnet --info 2> /dev/null;

	echo " ";
	echo "--------------------- Installed Java version ------------------------------";
	java -version 2> /dev/null;

	echo " ";
	echo "--------------------- Installed Java Compiler version ------------------------------";
	javac -version 2> /dev/null;	
	
	echo " ";
	echo "--------------------- Current Directory ------------------------------";
	pwd;

	echo " ";
	echo "--------------------- Users that is executing these scripts ------------------------------";
	whoami;
	
	echo " ";
	echo "--------------------- All users who are logged on the system ------------------------------";
	w;
	
	#echo " ";
	#echo "--------------------- All users who has access to this server ------------------------------";
	#getent passwd;

	echo " ";
	echo "--------------------- List all failed Services  ------------------------------";
	sudo systemctl list-units --state=failed 2>/dev/null 2>&1;

	echo " ";
	echo "--------------------- List Installed Application  ------------------------------";
	echo "Package Installed List...";
	apt list 2>/dev/null 2>&1;

	echo " ";
	echo "--------------------- List Application Upgradable  ------------------------------";
	apt list --upgradable 2>/dev/null 2>&1;

	echo " ";
	echo "... Someone who has sudo access can run 'sudo apt upgrade' to upgrade installed packages....";


	echo " ";
	echo "--------------------- System Information - End --------------------------------";



echo "--------------------- Predeployment End -----------------------------";
