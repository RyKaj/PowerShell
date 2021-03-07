System.gc();

echo "--------------------- Predeployment Start ---------------------------";

	echo "--------------------- System Information - Start ------------------------------";

	echo " ";
	echo "--------------------- Linux current kernal version ------------------------------";
	println "uname -mrs".execute().text

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
	println "free -m".execute().text


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
	println "ifconfig -a".execute().text
	println "ip link show".execute().text
	println "netstat -i".execute().text
	
	echo " ";
	echo "--------------------- Linux Default Gateway Information  ------------------------------";
	ip route | column -t;
	println "netstat -r".execute().text

	echo " ";
	echo "--------------------- Print Envionrmnet Variables   ------------------------------";
	echo "Evironment Variables"
	//sh "printenv | sort"
	System.getenv().each{
		println it
	} 

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
	println "pwd".execute().text

	echo " ";
	echo "--------------------- Users that is executing these scripts ------------------------------";
	println "whoami".execute().text
	
	echo " ";
	echo "--------------------- All users who are logged on the system ------------------------------";
	println "w".execute().text
	



groovy -version
https://stackoverflow.com/questions/16527384/checking-groovy-version-gradle-is-using

	echo " ";
	echo "--------------------- System Information - End --------------------------------";



echo "--------------------- Predeployment End -----------------------------";