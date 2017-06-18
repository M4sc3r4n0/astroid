#!/bin/bash

# setup.sh author Mascerano Bachir (dev-labs.co)
# Install all dependencies nedded for avoidz.rb tool
# --------------------------------------------------------

#Colors
cyan='\e[0;36m'
green='\e[0;32m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
path=`pwd`

#Check root exist
[[ `id -u` -eq 0 ]] > /dev/null 2>&1 || { echo  $red "You must be root to run the script"; exit 1; }
clear
#banner head
echo -e $blue ""
echo "                  __                .__    .___ "
echo " _____    _______/  |________  ____ |__| __| _/ "
echo " \__  \  /  ___/\   __\_  __ \/  _ \|  |/ __ |  "
echo "  / __ \_\___ \  |  |  |  | \(  <_> )  / /_/ |  "
echo " (____  /____  > |__|  |__|   \____/|__\____ |  "
echo "      \/     \/                             \/  "
echo "        Setup Script for ASTROID 1.2            "
echo "     Created by Mascerano Bachir/Dev-labs       "
#updating your distro
echo  
echo -e $green "[ ✔ ] system found."
echo -e $blue
sudo cat /etc/issue.net
echo
echo -e $green "[ ✔ ] updating distro."
echo -e $green
sudo apt-get update -y
#check dependencies existence
echo -e $blue ""
echo "---------------------------------------" 
echo "| Checking dependencies configuration |" 
echo "---------------------------------------" 
echo "                                       " 
# check if metasploit-framework is installed
which msfconsole > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Metasploit-Framework..............[ found ]"
which msfconsole > /dev/null 2>&1
sleep 2
else
echo -e $red "[ X ] Metasploit-Framework  -> not found "
echo -e $yellow "[ ! ] Installing Metasploit-Framework "
sudo apt-get install metasploit-framework -y
echo -e $blue "[ ✔ ] Done installing ...."
which msfconsole > /dev/null 2>&1
sleep 2
fi
#check if xterm is installed
which xterm > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Xterm.............................[ found ]"
which xterm > /dev/null 2>&1
sleep 2
else
echo ""
echo -e $red "[ X ] xterm -> not found! "
sleep 2
echo -e $yellow "[ ! ] Installing Xterm "
sleep 2
echo -e $green ""
sudo apt-get install xterm -y
clear
echo -e $blue "[ ✔ ] Done installing .... "
which xterm > /dev/null 2>&1
fi
# check if wine exists
which wine > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] wine..............................[ found ]"
which wine > /dev/null 2>&1
sleep 2
else
echo -e $red "[ X ] Wine  -> not found "
echo -e $yellow "[ ! ]  Installing wine "
echo -e $green ""
sudo dpkg --add-architecture i386 && apt-get update && apt-get install wine:i386 -y
echo -e $blue "[ ✔ ] Done installing ...."
which wine > /dev/null 2>&1
sleep 2
fi
# check if MinGw EXE exists
which mingw-gcc > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] MinGw EXE.........................[ found ]"
which mingw-gcc > /dev/null 2>&1
sleep 2
else
echo -e $red "[ X ] MinGw EXE  -> not found "
echo -e $yellow "[ ! ]  Installing MinGw EXE "
echo -e $green ""
wget https://downloads.sourceforge.net/project/mingw/Installer/mingw-get-setup.exe
wine mingw-get-setup.exe
echo -e $yellow "[ ! ]  Creating shortcut command MinGW"
echo "#!/bin/sh" >> /usr/bin/mingw-gcc
echo "cd /root/.wine/drive_c/MinGW/bin" >> /usr/bin/mingw-gcc
echo "exec wine gcc.exe \"\$@\"" >> /usr/bin/mingw-gcc
chmod +x /usr/bin/mingw-gcc
echo -e $blue "[ ✔ ] Done installing ...."
which mingw-gcc > /dev/null 2>&1
sleep 2
fi
# clone from govolution repo
echo -e $green "[ ! ] Cloning avet repo................[ proceed ]"
git clone https://github.com/govolution/avet.git
echo -e $blue "[ ✔ ] Done cloned ...."
sleep 2
mv avet/* $path
echo
directory="$path"
if test "$(ls -A "$directory")"; then

	echo -e $yellow "[ ! ] rebuild files "
	rm -r $directory/avet
	rm -r $directory/build
	rm $directory/README.md
	rm $directory/CHANGELOG
	rm $directory/LICENSE
	rm $directory/defs.h
	rm $directory/avet_fabric.py
	rm $directory/make_avet
	rm $directory/sh_format
fi
sleep 2
rm mingw-get-setup.exe > /dev/null 2>&1
gcc make_avet.c -o make_avet
gcc sh_format.c -o sh_format
sleep 2
echo 
echo -e $yellow "[ ! ] geving permission to astroid script"
chmod +x astroid.sh
sleep 2
echo
echo -e $green "--------------------------------------"
echo -e $blue "To execute astroid write (./astroid.sh)"
sleep 2
echo -e $green ""
echo "------------------------------------" 
echo "| [ ✔ ]installation completed[ ✔ ] |" 
echo "------------------------------------" 
echo
exit
